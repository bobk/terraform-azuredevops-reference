package test

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2019-09-01/keyvault"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureDevOpsReferenceRGKV(t *testing.T) {

	// this module demonstrates using the Terratest Azure Module and the Microsoft Azure SDK For Go to actively check the
	// existence and settings of the Terraform-created Azure resource(s) after they are created by Terraform.
	// We could use either API alone to do both checks, but are demoing both in one test for simplicity.

	t.Parallel()
	errorStr := ""

	// set up the terraform data structures and queue Destroy for later
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{TerraformDir: "../../tf/core/src"})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// examine Terraform output vars and use Terratest Azure Module to check that the resource(s) actually exist
	ARMsubscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	lz_core_rg_name := terraform.Output(t, terraformOptions, "lz-core_rg_name")
	fmt.Println("lz-core_rg_name = ", lz_core_rg_name)
	lz_core_rg_exists, err := azure.GetResourceGroupE(lz_core_rg_name, ARMsubscriptionId)
	if err != nil {
		errorStr = "Cannot get lz_core_rg_name resource group information: " + err.Error()
		fmt.Println(errorStr)
		assert.FailNow(t, errorStr)
	}
	fmt.Println("lz_core_rg_exists = ", lz_core_rg_exists)
	assert.True(t, lz_core_rg_exists)

	mgmt_core_rg_name := terraform.Output(t, terraformOptions, "mgmt-core_rg_name")
	fmt.Println("mgmt_core_rg_name = ", mgmt_core_rg_name)
	mgmt_core_rg_exists, err := azure.GetResourceGroupE(mgmt_core_rg_name, ARMsubscriptionId)
	if err != nil {
		errorStr = "Cannot get mgmt_core_rg_name resource group information: " + err.Error()
		fmt.Println(errorStr)
		assert.FailNow(t, errorStr)
	}
	fmt.Println("mgmt_core_rg_exists = ", mgmt_core_rg_exists)
	assert.True(t, mgmt_core_rg_exists)

	// for the KV, check its existence and also get its location for later
	lz_core_kv_name := terraform.Output(t, terraformOptions, "lz-core_kv_name")
	fmt.Println("lz-core_kv_name = ", lz_core_kv_name)
	keyvaultTerratestAzMod, err := azure.GetKeyVaultE(t, lz_core_rg_name, lz_core_kv_name, ARMsubscriptionId)
	if err != nil {
		errorStr = "Cannot get lz_core_kv_name key vault information: " + err.Error()
		fmt.Println(errorStr)
		assert.FailNow(t, errorStr)
	}
	actualkeyvaultLocationTerratestAzMod := *(keyvaultTerratestAzMod.Location)

	// now use Azure SDK For Go to also check the existence and location of the KV
	expectedkeyvaultLocation := "eastus"
	authorizer, err := auth.NewAuthorizerFromEnvironment()
	if err != nil {
		errorStr = "Cannot get an Azure authorizer: " + err.Error()
		fmt.Println(errorStr)
		assert.FailNow(t, errorStr)
	}
	keyvaultClient := keyvault.NewVaultsClient(ARMsubscriptionId)
	keyvaultClient.Authorizer = authorizer
	keyvaultMicrosoftAzureSDK, err := keyvaultClient.Get(context.Background(), lz_core_rg_name, lz_core_kv_name)
	if err != nil {
		errorStr = "Cannot get lz_core_kv_name key vault information: " + err.Error()
		fmt.Println(errorStr)
		assert.FailNow(t, errorStr)
	}
	actualkeyvaultLocationMicrosoftAzureSDK := *(keyvaultMicrosoftAzureSDK.Location)

	// now compare the expected value to the actual values from both APIs - this is the end-to-end testing validation
	fmt.Println("expectedkeyvaultLocation = ", expectedkeyvaultLocation)
	fmt.Println("actualkeyvaultLocationTerratestAzMod = ", actualkeyvaultLocationTerratestAzMod)
	fmt.Println("actualkeyvaultLocationMicrosoftAzureSDK = ", actualkeyvaultLocationMicrosoftAzureSDK)
	assert.Equal(t, expectedkeyvaultLocation, actualkeyvaultLocationTerratestAzMod)
	assert.Equal(t, expectedkeyvaultLocation, actualkeyvaultLocationMicrosoftAzureSDK)

}
