import { commands } from 'coc.nvim'
import { readFileSync } from 'fs'
import { exec } from 'child_process'
import { getApi } from './api'
import { getProjectRoot } from './utils'
import fetch from 'node-fetch'

function openChromeDevTools(url) {
  // for some reason the appleScript `open location` command does't work with this url, worked around using sequence of keystrokes
  // doesn't work from terminal `open -a 'Goole Chrome' ${url}` either
  const osascript = `
            osascript << 'END'
            tell application "Google Chrome"
                activate

                #force open devtools, shouldn't have to do that, buggy computer at work
                tell application "System Events" to keystroke "i" using { command down, option down }

                tell application "System Events" to keystroke "l" using command down
                delay 0.05
                tell application "System Events" to keystroke "${url}"
                tell application "System Events" to keystroke key code 36

                #close the devtools that I opened by force
                tell application "System Events" to keystroke "i" using { command down, option down }
            end tell
            END
             `
  // console.log(osascript)
  exec(osascript)
}

const openChromeOnDebuggerUrl = (port = 9229, retry = 0) =>
  fetch(`http://localhost:${port}/json/list`) //curl http://localhost:9229/json/list
    .then(response => response.json())
    .then(([{ devtoolsFrontendUrl, devtoolsFrontendUrlCompat }]) =>
      openChromeDevTools(devtoolsFrontendUrl || devtoolsFrontendUrlCompat)
    )
    .catch(() => {
      if (retry < 10) {
        setTimeout(() => openChromeOnDebuggerUrl(port, retry + 1), 100)
      }
    })

const runjest = async () => {
  const api = await getApi()
  let testPath = await api.nvim_eval("expand('%:p')")
  const projectRoot = getProjectRoot(testPath)
  testPath = testPath.replace(projectRoot, '').replace(/^\/?/, '')
  const {
    scripts: { test },
  } = JSON.parse(readFileSync(`${projectRoot}/package.json`).toString())
  const testCommand = test.replace(/.*\b(react-app-rewired|react-scripts|jest)\b.*/, '$1')
  const [runner, defaultArg] = testCommand === 'jest' ? ['ndb', ''] : ['node --inspect-brk', 'test']
  const command = `cd ${projectRoot}; CI=true FORCE_COLOR=true ${runner} $(yarn bin ${testCommand}) ${defaultArg} --testTimeout=999999 --no-coverage ${testPath}`

  await api.nvim_command('pedit')
  await api.nvim_command('wincmd P')
  await api.nvim_command('wincmd J')
  await api.nvim_command('setlocal nobuflisted')
  api.nvim_command(`terminal ${command}`)
  await api.nvim_command('nnoremap <buffer>q :bwipeout!<cr>')
  await api.nvim_command('tnoremap <buffer>q :bwipeout!<cr>')
  await api.nvim_command('wincmd p')
  openChromeOnDebuggerUrl()
}

commands.registerCommand('vim-js.runjest', runjest)
