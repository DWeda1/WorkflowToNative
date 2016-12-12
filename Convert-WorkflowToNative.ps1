$PathWorkflowNames = "C:\temp\Workflows.txt"
$PathCurrentScript = "C:\Users\Daan\Documents\Scripts\Powershellorg\Process.ps1"

#get Workflow names
$Workflownames = get-content -Path $PathWorkflowNames

#get current script
$AST = [System.Management.Automation.Language.Parser]::ParseFile($PathCurrentScript,[ref]$null,[ref]$Null) 

#get all info with the AST
$CmdletssInFile = $AST.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)
$CodeText= $AST.Extent.Text

#check all cmdlets that are workflows and change AST text
$CmdletssInFile|foreach-object {
                                $Command = $_.CommandElements[0]

                               

                                
                                if($Command.value -like "*inlineScript*")
                                                                        {$CodeText=$CodeText.replace($Command.value,"<#remove Inline SCRIPT here!#>"+ $Command.value)}
                                                                      

                                
                                if ($Command.Value -in $Workflownames)
                                                                     {
                                                                     Write-output "found one $($_.CommandElements.value)"
                                                                     $Readhost = Read-host "is $($_.CommandElements.value) a Workflow Runbook do you want to convert this to a Native PS Runbook, y=yes?"  
                                                                     Write-output $Readhost
                                                                     
                                                                     #change to Native scripts
                                                                     if($Readhost -eq 'y')
                                                                     {
                                                                     $Workflow = $_.CommandElements.value                                                                     
                                                                     $CodeText= $CodeText.replace($Workflow,"\."+ $Workflow +".ps1")
                                                                     }
                                                                     
                                                                     
                                                                     
                                                                     }

                                }
                                                              

#open new tab with fixed script
$ScriptWithoutWorkflow = $psISE.CurrentPowerShellTab.Files.Add() 
$ScriptWithoutWorkflow.Editor.Text = $CodeText

                                                                   
                                                                     
                                                                    
                                                               

                                                              


