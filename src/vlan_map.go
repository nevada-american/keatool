package main

import (
)
// add additional mappings as needed for your environment //
func get_subnet(key string) string {
	        vlan_to_subnet := map[string]string{
			"3000": "192.168.30.0/23",
		}
		subnet := vlan_to_subnet[key]
		return subnet
}
