#!/usr/bin/env node
const express = require("express");
const os = require("os");
const path = require("path");
const debounce = require("debounce");
const fetch = require("node-fetch");
const { writeFileSync, readFileSync, writeFile, existsSync } = require("fs");
const app = express();
const port = 2021;
const mruJsonPath = path.join(os.homedir(), ".local/share/jsMRU.json");
const mruTxt = process.env.MRU_TXT;

let mru;
function init() {
  if (!existsSync(mruJsonPath)) {
    writeFileSync(mruJsonPath, "{}");
  }

  mru = JSON.parse(readFileSync(mruJsonPath));
}
init();

const writeMru = debounce(() => {
  console.time("writeFile");
  writeFile(mruTxt, mruString(), (err) => err && console.log(err));
  writeFile(mruJsonPath, JSON.stringify(mru), (err) => {
    if (err) {
      console.log({ err });
    }
    console.timeEnd("writeFile");
  });
}, 80);

function mruString() {
  return Object.entries(mru)
    .sort((a, b) => b[1].date - a[1].date)
    .map(([file, { line, column }]) => `${file}:${line}:${column}`)
    .join("\n");
}

fetch(`http://localhost:${port}/ping`, { timeout: 15 })
  .then(() => {
    console.log("port is taken, assuming instance of jsmru");
    process.exit(0);
  })
  .catch(() => {
    app.use(express.json());
    app.get("/", (req, res) => {
      // no longer using this, read from file instead, it's faster and less flaky
      console.time("get");
      res.send(mruString());
      console.timeEnd("get");
    });

    app.post("/mru", (req, res) => {
      let { filepath, line, column, event, date = Date.now() } = req.body;
      res.sendStatus(200);
      // if I've manually modified mru file, re-read it to avoid overriding my manual changes
      if (filepath === mruJsonPath) init();
      if (filepath.startsWith("/private/var/folders/")) return;
      const oldData = mru[filepath];
      if (
        filepath !== mruJsonPath && //mruJson will allways rewrite to single line
        line + column === 2 && // line 1 column 1
        oldData &&
        /(BufWinEnter|BufReadPost|WinEnter)/.test(event)
      ) {
        ({ line, column } = oldData);
      }
      mru[filepath] = { line, column, date };
      if (filepath !== mruJsonPath) {
        writeMru();
      }
    });

    app.get("/removeMruInvalidEntries", (req, res) => {
      const deleted = [];
      for (const filename of Object.keys(mru)) {
        if (!existsSync(filename)) {
          delete mru[filename];
          deleted.push(filename);
        }
      }
      writeMru();
      res.send(deleted.join("\n"));
    });

    app.listen(port, () => {
      console.log(`Example app listening at http://localhost:${port}`);
    });
  });
