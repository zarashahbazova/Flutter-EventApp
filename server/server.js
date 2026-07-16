const WebSocket = require("ws");

const wss = new WebSocket.Server({
  port: 8080,
});

console.log("Sunucu çalışıyor...");

// Etkinlik listesi
let events = [];

// Otomatik ID
let nextId = 1;

// Bütün bağlı kullanıcılara listeyi gönder
function broadcastEvents() {
  const data = JSON.stringify({
    type: "events",
    events: events,
  });

  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

wss.on("connection", (ws) => {
  console.log("Yeni kullanıcı bağlandı.");

  // Yeni bağlanan kullanıcıya mevcut listeyi gönder
  ws.send(
    JSON.stringify({
      type: "events",
      events: events,
    })
  );

  ws.on("message", (message) => {
    const data = JSON.parse(message);

    // ETKİNLİK EKLE
    if (data.type === "add") {
      events.push({
        id: nextId++,
        title: data.title,
        time: data.time,
        date: data.date,
        location: data.location,
      });

      console.log("Etkinlik eklendi.");

      broadcastEvents();
    }

    // ETKİNLİK SİL
    else if (data.type === "delete") {
      events = events.filter(
        (event) => event.id !== data.id
      );

      console.log("Etkinlik silindi.");

      broadcastEvents();
    }

    // ETKİNLİK GÜNCELLE
    else if (data.type === "update") {

      const event = events.find(
        (e) => e.id === data.id
      );

      if (event) {
        event.title = data.title;
        event.time = data.time;
        event.location = data.location;

        console.log("Etkinlik güncellendi.");

        broadcastEvents();
      }
    }
  });

  ws.on("close", () => {
    console.log("Kullanıcı ayrıldı.");
  });
});