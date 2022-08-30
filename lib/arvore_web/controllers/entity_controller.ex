defmodule ArvoreWeb.EntityController do
  use ArvoreWeb, :controller

  alias Arvore.Partners
  alias Arvore.Partners.Entity

  action_fallback ArvoreWeb.FallbackController

  def index(conn, _params) do
    entities = Partners.list_entities()
    render(conn, "index.json", entities: entities)
  end

  def create(conn, entity_params) do
    with {:ok, %Entity{} = entity} <- Partners.create_entity(entity_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.entity_path(conn, :show, entity))
      |> render("show.json", entity: entity)
    end
  end

  def show(conn, %{"id" => id}) do
    entity = Partners.get_entity!(id)
    render(conn, "show.json", entity: entity)
  end

  def update(conn, %{"id" => id, "entity" => entity_params}) do
    entity = Partners.get_entity!(id)

    with {:ok, %Entity{} = entity} <- Partners.update_entity(entity, entity_params) do
      render(conn, "show.json", entity: entity)
    end
  end

  def delete(conn, %{"id" => id}) do
    entity = Partners.get_entity!(id)

    with {:ok, %Entity{}} <- Partners.delete_entity(entity) do
      send_resp(conn, :no_content, "")
    end
  end
end
