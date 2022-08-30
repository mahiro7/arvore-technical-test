defmodule ArvoreWeb.EntityControllerTest do
  use ArvoreWeb.ConnCase

  import Arvore.PartnersFixtures

  alias Arvore.Partners.Entity

  @create_attrs %{
    entity_type: "network",
    inep: nil,
    name: "some network"
  }
  @update_attrs %{
    entity_type: "school",
    inep: "123456",
    name: "some updated name"
  }
  @invalid_attrs %{entity_type: "invalid", inep: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all entities", %{conn: conn} do
      conn = get(conn, Routes.entity_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create entity" do
    test "renders entity when data is valid", %{conn: conn} do
      conn = post(conn, Routes.entity_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.entity_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "entity_type" => "network",
               "inep" => nil,
               "name" => "some network"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.entity_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "should not create entity without inep when school type", %{conn: conn} do
      conn = post(conn, Routes.entity_path(conn, :create), %{entity_type: "school", name: "some"})
      assert json_response(conn, 400)["error"] != %{}
    end

    test "should not create entity without parent_id when class type", %{conn: conn} do
      conn = post(conn, Routes.entity_path(conn, :create), %{entity_type: "class", name: "some"})
      assert json_response(conn, 400)["error"] != %{}
    end
  end

  describe "update entity" do
    setup [:create_entity]

    test "renders entity when data is valid", %{conn: conn, entity: %Entity{id: id} = entity} do
      conn = put(conn, Routes.entity_path(conn, :update, entity), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.entity_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "entity_type" => "school",
               "inep" => "123456",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, entity: entity} do
      conn = put(conn, Routes.entity_path(conn, :update, entity), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete entity" do
    setup [:create_entity]

    test "deletes chosen entity", %{conn: conn, entity: entity} do
      conn = delete(conn, Routes.entity_path(conn, :delete, entity))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.entity_path(conn, :show, entity))
      end
    end
  end

  defp create_entity(_) do
    entity = entity_fixture()
    %{entity: entity}
  end
end
