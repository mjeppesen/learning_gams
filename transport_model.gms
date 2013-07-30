* A simple 2 node, 1 line energy market type transport model to practice with gams
*
sets
  bids /bid_1/
  offers /offer_1, offer_2, offer_3/
  nodes /node_1, node_2/
  lines /line_1/;

alias (nodes, nodes_from), (nodes, nodes_to);

parameters
  bid_quantity(bids) /bid_1 100/

  bid_price(bids) /bid_1 200/;

$include offer_quantity

parameters
  offer_price(offers) /
    offer_1 15
    offer_2 75
    offer_3 30/

  line_capacity(lines) /line_1 50/;

* subsets
sets
  bids_nodes(bids, nodes) /
    bid_1.node_1 /

  offers_nodes(offers, nodes) /
    offer_1.node_1
    offer_2.node_1
    offer_3.node_2 /

  lines_nodes(lines, nodes_from, nodes_to) /
    line_1.node_1.node_2 /;

variables
  scheduled_bids(bids)
  scheduled_offers(offers)
  flows(lines)
  nodal_flow(nodes)
  z;

positive variables
  scheduled_bids
  scheduled_offers;

equations
  objective
  max_bid(bids)
  max_offer(offers)
  max_flow(lines)
  min_flow(lines)
  node_flow_sum(nodes)
  nodal_balance(nodes)
  conservation_of_energy;

objective..
  z =e= sum(bids, bid_price(bids) * scheduled_bids(bids))
    - sum(offers, offer_price(offers) * scheduled_offers(offers));

max_bid(bids)..
  scheduled_bids(bids) =l= bid_quantity(bids);

max_offer(offers)..
  scheduled_offers(offers) =l= offer_quantity(offers);

max_flow(lines)..
  flows(lines) =l= line_capacity(lines);

min_flow(lines)..
  flows(lines) =g= -1 * line_capacity(lines);

node_flow_sum(nodes)..
  nodal_flow(nodes) =e= sum(lines_nodes(lines, nodes_from, nodes), flows(lines)) -
  sum(lines_nodes(lines, nodes, nodes_to), flows(lines));

nodal_balance(nodes)..
  sum(offers_nodes(offers, nodes), scheduled_offers(offers))
  - sum(bids_nodes(bids, nodes), scheduled_bids(bids)) =e=
    nodal_flow(nodes);

conservation_of_energy..
  sum(bids, scheduled_bids(bids)) =e= sum(offers, scheduled_offers(offers));

model thing /all/;
solve thing using lp maximizing z;

display scheduled_bids.l, scheduled_offers.l;
display flows.l
display nodal_balance.m







