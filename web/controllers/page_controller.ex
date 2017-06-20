defmodule ChatzExs.PageController do
  use ChatzExs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
