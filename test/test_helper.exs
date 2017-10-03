ExUnit.start()

token = ExReddit.OAuth.get_token!
Application.put_env(:exreddit, :token, token)
