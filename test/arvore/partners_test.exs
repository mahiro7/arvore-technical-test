defmodule Arvore.PartnersTest do
  use Arvore.DataCase

  alias Arvore.Partners

  describe "entities" do
    alias Arvore.Partners.Entity

    import Arvore.PartnersFixtures

    @invalid_attrs %{entity_type: nil, inep: nil, name: nil}

    test "list_entities/0 returns all entities" do
      entity = entity_fixture()
      assert Partners.list_entities() == [entity]
    end

    test "get_entity!/1 returns the entity with given id" do
      entity = entity_fixture()
      assert Partners.get_entity!(entity.id) == entity
    end

    test "with valid data creates a entity" do
      valid_attrs = %{entity_type: "school", inep: "123456", name: "some name"}

      assert {:ok, %Entity{} = entity} = Partners.create_entity(valid_attrs)
      assert entity.entity_type == "school"
      assert entity.inep == "123456"
      assert entity.name == "some name"
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_entity(@invalid_attrs)
    end

    test "update_entity/2 with valid data updates the entity" do
      entity = entity_fixture()
      update_attrs = %{entity_type: "school", inep: "78984", name: "some updated name"}

      assert {:ok, %Entity{} = entity} = Partners.update_entity(entity, update_attrs)
      assert entity.entity_type == "school"
      assert entity.inep == "78984"
      assert entity.name == "some updated name"
    end

    test "update_entity/2 with invalid data returns error changeset" do
      entity = entity_fixture()
      assert {:error, %Ecto.Changeset{}} = Partners.update_entity(entity, @invalid_attrs)
      assert entity == Partners.get_entity!(entity.id)
    end

    test "delete_entity/1 deletes the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{}} = Partners.delete_entity(entity)
      assert_raise Ecto.NoResultsError, fn -> Partners.get_entity!(entity.id) end
    end

    test "change_entity/1 returns a entity changeset" do
      entity = entity_fixture()
      assert %Ecto.Changeset{} = Partners.change_entity(entity)
    end
  end
end
