if ActiveRecord::Base.respond_to? :default_scope
  Rails.logger.info "ActiveRecord::Base.default_scope found; default_scope_backport plugin skipped"
else
  require File.dirname(__FILE__) + "/lib/default_scope_backport"
end
