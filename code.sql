with revenue_usd as (
SELECT sp.continent,
      SUM (p.price) as revenue,
      SUM(case when device = 'mobile' then p.price end) as Revenue_from_Mobile,
      SUM(case when device = 'desktop' then p.price end) as Revenue_from_Desktop,
     
FROM `DA.order` o
JOIN `DA.product` p
ON o.item_id = p.item_id
JOIN `DA.session_params` sp
ON o.ga_session_id = sp.ga_session_id
GROUP BY sp.continent),


account as(
  SELECT sp.continent,
  COUNT (ac.id) as account_count,
  COUNT (case when ac.is_verified = 1 then ac.id end ) as verified_account,
  COUNT (sp.ga_session_id) as session_count
  FROM `DA.session_params` sp
  LEFT JOIN `DA.account_session` acs
  ON sp.ga_session_id = acs.ga_session_id
  LEFT JOIN `DA.account` ac
  ON acs.account_id = ac.id
  GROUP BY sp.continent)


  SELECT account.continent,
       revenue_usd.revenue,
       revenue_usd.Revenue_from_Mobile,
       revenue_usd.Revenue_from_Desktop,
       revenue_usd.revenue/ SUM (revenue_usd.revenue) OVER ()* 100 as revenue_from_total,
       account.account_count,
       account.verified_account,
       account.session_count

  FROM account
  LEFT JOIN revenue_usd
  ON revenue_usd.continent = account.continent
 



