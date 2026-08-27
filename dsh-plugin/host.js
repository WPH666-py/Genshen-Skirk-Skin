// ============================================================
// 丝柯克（Skirk）动态皮肤插件 · Host（独立版 · 可选全画质模式）
// ------------------------------------------------------------
// 零配置模式（推荐）无需本文件：client.js 已内嵌素材。
// 想要原图画质时，把本文件内容粘贴到 code.host、client.js
// 粘贴到 code.client 一起 define/run 即可。客户端会自动检测
// 到本 Host 并切换为路由素材。
// 唯一需要修改的：把 ASSET_DIR 改成素材文件夹在你机器上的
// 绝对路径（Windows 用正斜杠或双反斜杠）。
// ============================================================
const ASSET_DIR = 'D:/projects-py/原始系列皮肤插件/丝柯克动态皮肤插件（独立版）/素材'
const MAX_BYTES = 8 * 1024 * 1024
const ROUTES = [
  { route: '/skirk-skin/skin.png', file: '丝柯克.png', type: 'image/png' },
  { route: '/skirk-skin/burst.mp3', file: '语音-元素爆发·沉于渊海.mp3', type: 'audio/ogg' },
]
const join = (dir, name) => dir.replace(/[\\/]+\s*$/, '') + '/' + name

return {
  apply(ctx) {
    const fs = ctx.get('fs')
    const webServer = ctx.get('webServer')
    if (fs === undefined || webServer === undefined) {
      console.error('skirk-skin: host services fs/webServer unavailable')
      return
    }
    const cache = new Map()
    const load = (file) => {
      if (!cache.has(file)) {
        cache.set(file, (async () => {
          const target = await fs.resolve(join(ASSET_DIR, file))
          return await fs.readBytes(target, undefined, MAX_BYTES)
        })())
      }
      return cache.get(file)
    }
    ctx.effect(() => {
      const disposers = []
      for (const route of ROUTES) {
        try {
          disposers.push(webServer.register({
            kind: 'exact',
            path: route.route,
            handler: async (req, res) => {
              try {
                const bytes = await load(route.file)
                res.writeHead(200, {
                  'Content-Type': route.type,
                  'Content-Length': String(bytes.length),
                  'Cache-Control': 'no-cache',
                })
                res.end(bytes)
              } catch (error) {
                console.error('skirk-skin: serve failed', route.file, error)
                if (!res.headersSent) {
                  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' })
                }
                res.end('asset unavailable: ' + route.file)
              }
            },
          }))
        } catch (error) {
          console.error('skirk-skin: route register failed', route.route, error)
        }
      }
      return () => { for (const dispose of disposers) dispose() }
    })
    ctx.effect(() => harness.handle('skirk-urls', () => ({
      skin: '/skirk-skin/skin.png',
      burst: '/skirk-skin/burst.mp3',
    })))
  },
}
