require 'spec_helper'

describe port( property[:httpd_port] || 80) do
  it { should be_listening }
end
