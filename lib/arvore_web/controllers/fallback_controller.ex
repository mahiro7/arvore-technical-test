defmodule ArvoreWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ArvoreWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ArvoreWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ArvoreWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, {:check_constraint, message}}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ArvoreWeb.ErrorView)
    |> render("error.json", message: message)
  end
end
