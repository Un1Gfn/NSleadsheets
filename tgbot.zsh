#!/bin/zsh

source tgbot.apitoken

# https://stackoverflow.com/a/38388851/
# https://core.telegram.org/bots/api#getupdates
getUpdates=(
  curl
  -v
  -x socks5://127.0.0.1:7890
  https://api.telegram.org/bot$TOKEN/getUpdates
)

# https://core.telegram.org/bots/features#local-bot-api
# https://stackoverflow.com/a/56119656/
# https://core.telegram.org/bots/api#senddocument
sendDocument=(
  curl
  -v
  -x socks5://127.0.0.1:7890
  -F chat_id=-1001901971192
  -F document=@$1
  # -F caption=TheCaption
  https://api.telegram.org/bot$TOKEN/sendDocument
)

${sendDocument[@]}
