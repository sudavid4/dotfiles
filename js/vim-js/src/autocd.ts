import { debounce } from 'debounce'
import { commands, workspace } from 'coc.nvim'
import path from 'path'
import os from 'os'
import { existsSync, writeFileSync, readFileSync } from 'fs'

const { nvim } = workspace
const dirMap = path.join(os.homedir(), '.local', 'share', 'nvim', 'vimJsAutoCd.json')
const writeJsonSync = obj => writeFileSync(dirMap, JSON.stringify(obj))

let sessionSelectedDirectories: Array<string> = []

const nvimConfigDir = path.join(os.homedir(), '.dotfiles/config/nvim')
const getProjectsMap = () => JSON.parse(readFileSync(dirMap, { encoding: 'utf8' }))

function getRoot(directory, isRoot) {
  if (!directory || directory === '/' || directory === os.homedir()) {
    return ''
  }
  if (isRoot(directory)) {
    return directory
  }
  return getRoot(path.dirname(directory), isRoot)
}

const isGitRoot = dir => existsSync(path.join(dir, '.git'))

const getProjectRoot = dir => getRoot(dir, p => existsSync(path.join(p, 'package.json')) || p === nvimConfigDir)
const getGitRoot = dir => getRoot(dir, isGitRoot)

const isInvalidAutoCDBuffer = (currentDir, ft) =>
  !path.isAbsolute(currentDir) || ft === 'coc-explorer' || !currentDir.startsWith('/')

const CD = dir => dir !== workspace.cwd && nvim.command(`cd ${dir}`)

const executer = fn => async () => {
  const [currentDir, fileType] = (await nvim.eval("[expand('%:p:h'), &filetype]")) as [string, string]
  if (isInvalidAutoCDBuffer(currentDir, fileType)) return
  fn({
    fileType,
    currentDir,
    projectsRootDicts: getProjectsMap(),
    gitRoot: getGitRoot(currentDir),
    projectRoot: getProjectRoot(currentDir),
  })
}

const cdGitRoot = executer(function ({ gitRoot, projectsRootDicts }) {
  if (gitRoot) {
    CD(gitRoot)
    projectsRootDicts.roots[gitRoot] = true
    writeJsonSync(projectsRootDicts)
  }
})

const cdProjectRoot = executer(function ({ projectsRootDicts, gitRoot, projectRoot }) {
  if (projectRoot) {
    CD(projectRoot)
    delete projectsRootDicts.roots[gitRoot]
    sessionSelectedDirectories = sessionSelectedDirectories.filter(a => !projectRoot.startsWith(a))
    writeJsonSync(projectsRootDicts)
  }
})

const cdCurrentPath = executer(function ({ currentDir, gitRoot }) {
  CD(currentDir)
  const projectsRootDicts = getProjectsMap()
  delete projectsRootDicts.roots[gitRoot]
  sessionSelectedDirectories = sessionSelectedDirectories.filter(a => !a.startsWith(currentDir))
  sessionSelectedDirectories.push(currentDir)
  writeJsonSync(projectsRootDicts)
})

const onChangeDirectory = executer(function () {
  const { cwd } = workspace
  sessionSelectedDirectories = sessionSelectedDirectories.filter(a => !a.startsWith(cwd))
  if (!isGitRoot(cwd) && cwd !== os.homedir() && cwd !== nvimConfigDir) {
    sessionSelectedDirectories.push(workspace.cwd)
  }
})

const onBufferChange = executer(
  debounce(function ({ projectsRootDicts, currentDir, gitRoot, projectRoot }) {
    sessionSelectedDirectories = sessionSelectedDirectories.filter(dir => !(gitRoot || projectRoot).startsWith(dir))

    for (const dir of [...sessionSelectedDirectories, ...Object.keys(projectsRootDicts.roots)].sort(
      (a, b) => b.length - a.length
    )) {
      if (currentDir.startsWith(dir)) {
        CD(dir)
        return
      }
    }
    onVimEnter({ projectsRootDicts, currentDir, gitRoot, projectRoot })
  }, 30)
)

if (!existsSync(dirMap)) {
  writeJsonSync({ roots: {} })
}
function onVimEnter({ projectsRootDicts, currentDir, gitRoot, projectRoot }) {
  if (projectRoot && gitRoot.startsWith(projectRoot as string)) {
    // looks like .../config/nvim/plugged/someproj
    return CD(gitRoot)
  }
  if (gitRoot in projectsRootDicts.roots) {
    return CD(gitRoot)
  }
  if (projectRoot) {
    return CD(projectRoot)
  }
  CD(currentDir)
}

workspace.registerAutocmd({ event: 'DirChanged', request: true, callback: onChangeDirectory })
workspace.registerAutocmd({ event: 'BufWinEnter', request: false, callback: onBufferChange })
workspace.registerAutocmd({ event: 'WinEnter', request: false, callback: onBufferChange })

commands.registerCommand('vim-js.cdGitRoot', cdGitRoot)
commands.registerCommand('vim-js.cdProjectRoot', cdProjectRoot)
commands.registerCommand('vim-js.cdCurrentPath', cdCurrentPath)

nvim.command('command! CDG :CocCommand vim-js.cdGitRoot')
nvim.command('command! CDR :CocCommand vim-js.cdProjectRoot')
nvim.command('command! CDC :CocCommand vim-js.cdCurrentPath')

executer(onVimEnter)()
