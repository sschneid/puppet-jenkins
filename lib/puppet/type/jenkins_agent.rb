module Puppet
  newtype(:jenkins_agent) do
    ensurable do
      defaultvalues
      defaultto :present
    end

    newparam(:name) do
      desc "Hostname of the jenkins agent"
      isnamevar
    end

    newparam(:username) do
      desc "Username on the jenkins server"
      defaultto :false
    end

    newparam(:password) do
      desc "Password on the jenkins server"
      defaultto :false
    end

    newparam(:server) do
      desc "Hostname of the jenkins master"
    end

    newparam(:executors) do
      desc "Number of executors"
      defaultto 5
    end
  end
end
