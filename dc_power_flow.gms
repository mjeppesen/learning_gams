sets
  bid /bid1, bid2, bid3/
  offer /offer1, offer2, offer3, offer4, offer5, offer6/;
parameters
  bid_quantity(bid)
  / bid1    70
    bid2    60
    bid3   150/

  bid_price(bid) /
    bid1 200
    bid2 77
    bid3 500/

  offer_quantity(offer) /
    offer1 100
    offer2 100
    offer3 50
    offer4 50
    offer5 10
    offer6 10/

  offer_price(offer) /
    offer1 55
    offer2 75
    offer3 40
    offer4 70
    offer5 35
    offer6 80/;

variables
  scheduled_bid(bid)
  scheduled_offer(offer)
  z;

positive variables
  scheduled_bid
  scheduled_offer;

equations
  objective
  max_bid(bid)
  max_offer(offer)
  conservation_of_energy;

objective.. z =e= sum(bid, bid_price(bid) * scheduled_bid(bid)) - sum(offer, offer_price(offer) * scheduled_offer(offer));

max_bid(bid).. scheduled_bid(bid) =l= bid_quantity(bid);

max_offer(offer).. scheduled_offer(offer) =l= offer_quantity(offer);

conservation_of_energy.. sum(bid, scheduled_bid(bid)) =e= sum(offer,scheduled_offer(offer))

model thing /all/;
solve thing using lp maximizing z;

display scheduled_bid.l, scheduled_offer.l;







