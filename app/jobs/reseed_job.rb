# encoding: utf-8

#  Copyright (c) 2012-2017, Hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_generic.

class ReseedJob < RecurringJob

  run_every 24.hours

  private

  def perform_internal
    system 'bundle exec rake db:reseed'
  end

end
