# encoding: utf-8

#  Copyright (c) 2012-2013, Puzzle ITC GmbH. This file is part of
#  hitobito_generic and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_generic.

require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

class GenericPersonSeeder < PersonSeeder

  def seed_demo_person(email, group, role_type)
    attrs = person_attributes(role_type).merge(email: email)
    p = Person.seed(:email, attrs).first
    seed_accounts(p, false)
    seed_role(p, group, role_type)
  end
end


seeder = GenericPersonSeeder.new

seeder.seed_all_roles

root = Group.root

seeder.encrypted_password = BCrypt::Password.create("demo", cost: 1)
seeder.seed_demo_person('dennis.rankl@spoe.at', root, Group::TopLayer::Administrator)
