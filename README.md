# NodeFormula
An Open Source Formula to Rate Sentinel DVPN Nodes

## Idea
Decentralized networks have their drawbacks when providing services to consumers, such as no SLA agreements, no guarantee of service, no support tickets, and no way of knowing whether what you paid for will be there the follwing day. Because of this, there needs to be a self-regulating entity that ensures users can trust the node they are subscribing to. 

This is why we have created **Meile Node Formula**

### Formula

```
NF = 5w + 25x + 20y + δ
```

where
`w = avg(user submitted ratings)` and `1≤w≤10`,
`x = uptime_rate` and `0≤x≤1`
`y = days online as rate` and `0≤y≤1`
`δ = ASN score` and 

```
δ = 1, if datacenter
δ = 3, if business ISP
δ = 5, if residential
```

Thus, it can be readily seen that `0≤NF≤100` - A number we can all understand 

Emphasis is put on node uptime and node days online as a gauging factor to the QoS of the node in question, with the most emphasis put on user submitted ratings. 

#### Exceptions
If a node comes online and no user has submitted a rating for this node, than the NodeFormula (`NF`) will show a `NULL` value in **Meile**. Therefore the NodeFormula is dependent on user submitted ratings. 

Some values for nodes have a default value when there is little or no data. This does not affect the overall scoring and can be seen as marginal. 

## Repository
This repository contains the SQL required to compute the `node_formula` table that will be implemented in **Meile**. To gather all the data for this please see [Meile Cache Server](https://github.com/MathNodes/meile-cache-server)

