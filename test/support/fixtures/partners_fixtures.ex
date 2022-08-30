defmodule Arvore.PartnersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Arvore.Partners` context.
  """

  @doc """
  Generate a entity.
  """
  def entity_fixture(attrs \\ %{}) do
    {:ok, entity} =
      attrs
      |> Enum.into(%{
        entity_type: "network",
        inep: nil,
        name: "network name"
      })
      |> Arvore.Partners.create_entity()

    entity
    |> Arvore.Partners.preload_children()
  end
end
