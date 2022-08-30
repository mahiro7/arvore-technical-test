defmodule Arvore.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :entity_type, :string
      add :inep, :string
      add :parent_id, references(:entities, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:entities, [:parent_id])

    execute "
    ALTER TABLE entities
      ADD CONSTRAINT chk_valid_entity_types CHECK (entity_type = 'network' OR entity_type = 'school' OR entity_type = 'class'),
      ADD CONSTRAINT chk_inep_is_null CHECK ((inep IS NOT NULL AND entity_type = 'school') OR (inep IS NULL AND entity_type != 'school')),
      ADD CONSTRAINT chk_class_type_should_have_parent_id CHECK ((parent_id IS NOT NULL AND entity_type = 'class') OR entity_type != 'class');
    "

    execute "
    CREATE TRIGGER checks_before_insert BEFORE INSERT ON entities
    FOR EACH ROW
    BEGIN
      IF NEW.entity_type = 'class' AND (SELECT entity_type FROM entities e WHERE e.id = NEW.parent_id) != 'school' THEN
        SIGNAL SQLSTATE '12345'
          SET MESSAGE_TEXT = 'check constraint on entity_type failed';
      END IF;
    END
    "
  end
end
