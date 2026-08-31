using './main.bicep'

// General Parameters
param parLocations = [
  'westus3'
]

param parTags = {
  purpose: 'pr164-dns-delegation-test'
  environment: 'sandbox'
}

param parEnableTelemetry = true

param parGlobalResourceLock = {
  name: 'GlobalResourceLock'
  kind: 'None'
  notes: 'PR 164 DNS Private Resolver delegation validation.'
}

// Resource Group Parameters
param parVirtualWanResourceGroupNamePrefix = 'rg-pr164-vwan'
param parDnsResourceGroupNamePrefix = 'rg-pr164-dns'
param parDnsPrivateResolverResourceGroupNamePrefix = 'rg-pr164-dnspr'

// Virtual WAN Parameters
param vwan = {
  name: 'vwan-pr164-westus3'
  location: parLocations[0]
  type: 'Standard'
  allowBranchToBranchTraffic: true
  lock: {
    kind: 'None'
    name: 'vwan-pr164-lock'
    notes: 'PR 164 validation lock configuration.'
  }
}

// Virtual WAN Hub Parameters
param vwanHubs = [
  {
    hubName: 'vhub-pr164-westus3'
    location: parLocations[0]
    addressPrefix: '10.164.0.0/22'
    allowBranchToBranchTraffic: true
    preferredRoutingGateway: 'ExpressRoute'

    azureFirewallSettings: {
      deployAzureFirewall: false
      name: 'afw-pr164-westus3'
    }

    expressRouteGatewaySettings: {
      deployExpressRouteGateway: false
      name: 'ergw-pr164-westus3'
      minScaleUnits: 1
      maxScaleUnits: 1
      allowNonVirtualWanTraffic: false
    }

    s2sVpnGatewaySettings: {
      deployS2sVpnGateway: false
      name: 's2s-pr164-westus3'
      scaleUnit: 1
    }

    p2sVpnGatewaySettings: {
      deployP2sVpnGateway: false
      name: 'p2s-pr164-westus3'
      scaleUnit: 1
      vpnServerConfiguration: {
        vpnAuthenticationTypes: [
          'AAD'
        ]
      }
      vpnClientAddressPool: {
        addressPrefixes: [
          '172.164.0.0/24'
        ]
      }
    }

    ddosProtectionPlanSettings: {
      deployDdosProtectionPlan: false
    }

    dnsSettings: {
      deployPrivateDnsZones: true
      deployDnsPrivateResolver: true
      privateDnsResolverName: 'dnspr-pr164-westus3'
    }

    bastionSettings: {
      deployBastion: false
      name: 'bas-pr164-westus3'
      sku: 'Standard'
    }

    sideCarVirtualNetwork: {
      name: 'vnet-sidecar-pr164-westus3'
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: [
        '10.164.4.0/22'
      ]
    }
  }
]
