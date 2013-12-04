###
  irc-message
  Copyright (c) 2013 Fionn Kelleher. All rights reserved.
  Licensed under the BSD 2-Clause License (FreeBSD) - see LICENSE.md.
###

Transform = require("stream").Transform
Message = require "irc-message"
util = require "util"

class MessageStream
  constructor: (options) ->
    @buffer = ""
    Transform.call(this, options)

util.inherits MessageStream, Transform

MessageStream::_transform = (chunk, encoding, done) ->
  @buffer += chunk.toString()
  lines = @buffer.split "\r\n"
  @buffer = lines.pop()
  lines.forEach (line) =>
    @emit "line", line
    try
      message = new Message line
      @emit "parsed", message
    catch err
      @emit "error", err
  done()

exports = module.exports = MessageStream