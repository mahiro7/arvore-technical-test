defmodule Arvore.Partners.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entities" do
    field :entity_type, :string
    field :inep, :string
    field :name, :string
    field :parent_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :entity_type, :inep, :parent_id])
    |> validate_required([:name, :entity_type])
  end
end
