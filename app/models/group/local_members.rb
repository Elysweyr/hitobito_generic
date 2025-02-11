# encoding: utf-8

#  Copyright (c) 2012-2013, Puzzle ITC GmbH. This file is part of
#  hitobito_generic and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_generic.

class Group::LocalMembers < Group::Members

  children Group::LocalMembers

  class Leader < Role::Leader
  end

  class ActiveMember < Role::ActiveMember
    self.permissions =  [:group_and_below_read]
  end

  class SupportingMember < Role::SupportingMember
    self.permissions =  [:group_and_below_read]
  end

  class PastMember < Role::PastMember
  end

  class PassiveMember < Role::PassiveMember
  end


  class AddressManager < Role::AddressManager
  end

  self.default_role = ActiveMember
  roles Leader, AddressManager, ActiveMember, PassiveMember, SupportingMember, PastMember
end

