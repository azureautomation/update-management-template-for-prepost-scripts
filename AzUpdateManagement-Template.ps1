
<#PSScriptInfo

.VERSION 1.1

.GUID 5a1ed24c-9099-4921-a135-bfc13213619b

.AUTHOR dmohanta

.COMPANYNAME Microsoft

.COPYRIGHT 

.TAGS UpdateManagement, Automation

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


.PRIVATEDATA 

#>

<# 

.DESCRIPTION 
 This is a template script for Update Management pre/post actions.
 It contains a basic list of common tasks and can be used to write your own scripts. 

#> 

<#
.SYNOPSIS
 Barebones script for Update Management Pre/Post

.DESCRIPTION
  This script is intended to be run as a part of Update Management Pre/Post scripts. 
  It requires a System Managed Identity.

.PARAMETER SoftwareUpdateConfigurationRunContext
  This is a system variable which is automatically passed in by Update Management during a deployment.
#>

param(
    [string]$SoftwareUpdateConfigurationRunContext
)
#region BoilerplateAuthentication
#This requires a System Managed Identity
$AzureContext = (Connect-AzAccount -Identity).context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
#endregion BoilerplateAuthentication

Write-Output "Input: $SoftwareUpdateConfigurationRunContext"
#If you wish to use the run context, it must be converted from JSON
$context = ConvertFrom-Json  $SoftwareUpdateConfigurationRunContext
Write-Output "Context: $context" 
$RunId = $context.SoftwareUpdateConfigurationRunId
Write-Output "Run ID: $RunID"
#Configuration settings is another JSON and must be parsed again
$Settings = ConvertFrom-Json $context.SoftwareUpdateConfigurationSettings
Write-Output "List of settings: $Settings"
$VmIds = $Settings.AzureVirtualMachines
Write-Output "Azure VMs: $VmIds"


#Example: How to create and write to a variable using the pre-script:
<#
#Create variable named after this run so it can be retrieved
New-AzAutomationVariable -ResourceGroupName $ResourceGroup –AutomationAccountName $AutomationAccount –Name $runId -Value "" –Encrypted $false
#Set value of variable 
Set-AzAutomationVariable –Name $runId -Value $vmIds -ResourceGroupName $ResourceGroup –AutomationAccountName $AutomationAccount –Encrypted $false
#>

#Example: How to retrieve information from a variable set during the pre-script
<#
$variable = Get-AzAutomationVariable -Name $runId -ResourceGroupName $ResourceGroup -AutomationAccountName $AutomationAccount
#> 