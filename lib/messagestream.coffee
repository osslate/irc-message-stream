###
  irc-message
  Copyright (c) 2013 Fionn Kelleher. All rights reserved.
  Licensed under the BSD 2-Clause License (FreeBSD) - see LICENSE.md.
###

Transform = require("stream").Transform
Message = require "irc-message"
util = require "util"

class MessageStream
  constructor: (options = {}) ->
    options.objectMode = true
    Transform.call(this, options)
    @buffer = ""

util.inherits MessageStream, Transform

MessageStream::_transform = (chunk, encoding, done) ->
  @buffer += chunk.toString()
  lines = @buffer.split "\r\n"
  @buffer = lines.pop()
  for line in lines
    @emit "line", line
    message = Message line
    if message != null
      @push message
    else
      @emit "error", new Error "Unparsable IRC message received."
  done()

exports = module.exports = MessageStream
