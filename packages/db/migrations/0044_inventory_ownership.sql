begin;

insert into roles (id, business_id, name, description)
select gen_random_uuid(), b.id, 'stock_owner', 'Usuario con inventario propio'
from businesses b
where not exists (
  select 1 from roles r where r.business_id = b.id and r.name = 'stock_owner'
);

alter table inventory_items
  add column if not exists owner_user_id uuid references app_users(id) on delete restrict;

alter table sale_items
  add column if not exists owner_user_id uuid references app_users(id) on delete set null;

create index if not exists idx_inventory_items_owner
  on inventory_items (business_id, owner_user_id, active, updated_at desc);

create index if not exists idx_sale_items_owner
  on sale_items (business_id, owner_user_id);

commit;
