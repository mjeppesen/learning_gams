sets
  bid /bid_1*bid_3/
  offer /offer_1*offer_6/;

parameters
  bid_quantity(bid)
  / bid_1    70
    bid_2    60
    bid_3   150/

  bid_price(bid) /
    bid_1 200
    bid_2 77
    bid_3 500/

  offer_quantity(offer) /
    offer_1 100
    offer_2 100
    offer_3 50
    offer_4 50
    offer_5 10
    offer_6 10/

  offer_price(offer) /
    offer_1 55
    offer_2 75
    offer_3 40
    offer_4 70
    offer_5 35
    offer_6 80/;

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







