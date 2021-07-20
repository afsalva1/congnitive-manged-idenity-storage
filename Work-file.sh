az cognitiveservices account identity assign --name 'afsaL-cogntive-cogsvc-test-three' --resource-group 'Afsal-storage-RG-One' --query principalId --output tsv

az cognitiveservices account identity assign --name afsaL-cogntive-cogsvc-test-three --resource-group Afsal-storage-RG-One

az cognitiveservices account identity remove --name afsaL-cogntive-cogsvc-test-three --resource-group Afsal-storage-RG-One
