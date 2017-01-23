Puppet::Type.newtype(:testlink_extension) do
    @doc = "Manage testlink Extensions"

    ensurable

    newparam(:name) do
       desc "The name of the extension to be managed"

       isnamevar
    end

    newparam(:source) do
      desc "The location of the Extension to be loaded."
    end
 
    newparam(:instance) do
      desc "testlink puppet instance identifier."
    end
 
    newparam(:doc_root) do
      desc "testlink base installation path."
    end

end
