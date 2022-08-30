defmodule ArvoreWeb.EntityView do
  use ArvoreWeb, :view
  alias ArvoreWeb.EntityView

  def render("index.json", %{entities: entities}) do
    %{data: render_many(entities, EntityView, "entity.json")}
  end

  def render("show.json", %{entity: entity}) do
    %{data: render_one(entity, EntityView, "entity.json")}
  end

  def render("entity.json", %{entity: entity}) do
    %{
      id: entity.id,
      name: entity.name,
      entity_type: entity.entity_type,
      inep: entity.inep
    }
  end
end
