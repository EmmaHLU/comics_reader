const {onSchedule} = require("firebase-functions/v2/scheduler");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");
// 引入全局 fetch (假设运行环境为 Node 18+,
// 已内置 fetch)

initializeApp();

exports.checkNewXkcdComic = onSchedule(
    {
      // 每天 23:00 运行
      schedule: "0 23 * * *",
      timeZone: "Europe/Oslo",
    },
    async (event) => {
      // 运行时检查全局 fetch 是否可用
      if (typeof fetch === "undefined") {
        console.error("Global fetch is not available.");
        // 如果运行在较旧的 Node 环境中，
        // 可能需要安装并使用 node-fetch
        return;
      }

      try {
        // 1. 获取最新的 XKCD 漫画数据
        const res = await fetch("https://xkcd.com/info.0.json");

        if (!res.ok) {
          // 使用模板字符串和双引号
          throw new Error(`Failed to fetch XKCD comic: ${res.statusText}`);
        }

        // 2. 将 JSON 解析为 JavaScript 对象
        const latest = await res.json();

        // 3. 构造 FCM 消息
        const message = {
          notification: {
            title: `New XKCD #${latest.num}`,
            body: latest.title,
          },
          // 发送到订阅了 'xkcd_notifications' 主题的所有用户
          topic: "xkcd_notifications",
        };

        // 4. 发送通知
        await getMessaging().send(message);
        console.log("Notification sent for XKCD", latest.num);
      } catch (error) {
        console.error("Error checking or sending XKCD notification:", error);
      }
    }, // 修复行尾缺少逗号的错误 (Missing trailing comma)
);
