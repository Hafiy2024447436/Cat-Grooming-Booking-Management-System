-- Run this after importing rows that already contain explicit numeric IDs.
-- It advances each sequence so the next generated ID does not collide.

SELECT setval('staffid_seq', COALESCE(MAX(staffid), 1), MAX(staffid) IS NOT NULL) FROM staff;
SELECT setval('custid_seq', COALESCE(MAX(custid), 1), MAX(custid) IS NOT NULL) FROM customer;
SELECT setval('breedid_seq', COALESCE(MAX(breedid), 1), MAX(breedid) IS NOT NULL) FROM breed;
SELECT setval('catid_seq', COALESCE(MAX(catid), 1), MAX(catid) IS NOT NULL) FROM cat;
SELECT setval('serviceid_seq', COALESCE(MAX(serviceid), 1), MAX(serviceid) IS NOT NULL) FROM service;
SELECT setval('appointmentid_seq', COALESCE(MAX(appointmentid), 1), MAX(appointmentid) IS NOT NULL) FROM appointment;
