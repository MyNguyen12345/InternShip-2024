class ApplicationController < ActionController::Base
  def hello
    # render html: "hello, word"
    # render html: "¡Hola, mundo!"
    render html: "goodbye, world!"
  end
end
