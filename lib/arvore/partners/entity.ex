defmodule Arvore.Partners.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Arvore.Partners.Entity

  schema "entities" do
    field :entity_type, :string
    field :inep, :string
    field :name, :string

    belongs_to :parent, Entity
    has_many :children, Entity, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :entity_type, :inep, :parent_id])
    |> cast_assoc(:parent)
    |> cast_assoc(:children)
    |> validate_required([:name, :entity_type])
  end
end
