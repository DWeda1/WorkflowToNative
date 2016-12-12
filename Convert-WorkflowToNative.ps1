 $PathWorkflowNames = "C:\temp\Workflows.txt"
$PathCurrentScript = "C:\Users\Daan\Documents\Scripts\Powershellorg\Process.ps1"

#Get Workflow names
$Workflownames = get-content -Path $PathWorkflowNames

#Get current script
$AST = [System.Management.Automation.Language.Parser]::ParseFile($PathCurrentScript,[ref]$null,[ref]$Null) 

#Get all info with the AST
$CmdletssInFile = $AST.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)
$CodeText= $AST.Extent.Text

#Check all cmdlets that are workflows and change AST text
$CmdletssInFile|foreach-object {
                                $Command = $_.CommandElements[0]

                               

                                
                                if($Command.value -like "*inlineScript*")
                                                                        {$CodeText=$CodeText.replace($Command.value,"<#remove Inline SCRIPT here!#>"+ $Command.value)}
                                                                      

                                
                                if ($Command.Value -in $Workflownames)
                                                                     {
                                                                     Write-output "found one $($_.CommandElements.value)"
                                                                     $Readhost = Read-host "is $($_.CommandElements.value) a Workflow Runbook do you want to convert this to a Native PS Runbook, y=yes?"  
                                                                     Write-output $Readhost
                                                                     
                                                                     #Change to Native scripts
                                                                     if($Readhost -eq 'y')
                                                                     {
                                                                     $Workflow = $_.CommandElements.value                                                                     
                                                                     $CodeText= $CodeText.replace($Workflow,"\."+ $Workflow +".ps1")
                                                                     }
                                                                     
                                                                     
                                                                     
                                                                     }

                                }
                                                              

#Open new tab with converted script
$ScriptWithoutWorkflow = $psISE.CurrentPowerShellTab.Files.Add() 
$ScriptWithoutWorkflow.Editor.Text = $CodeText

                                                                   
                                                                     
                                                                    
                                                               

                                                              

　
 
