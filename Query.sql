
---1)--Product isimlerini (`ProductName`) ve birim başına miktar
--(`QuantityPerUnit`) değerlerini almak için sorgu yazın.
Select product_name , quantity_per_unit from products

--2)--Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın.
--Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz

Select product_id , product_name from products where discontinued=0

--3)--Durdurulan Ürün Listesini, Ürün kimliği ve
--ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
Select product_id, product_name, discontinued
from products
where discontinued = 1;


--4)--Ürünlerin maliyeti 20'dan az olan Ürün listesini
--(`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.

Select product_id, product_name, unit_price from products where unit_price <20  

--5)--Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini
--`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın

select product_id, product_name, unit_price from products where unit_price between 15 and 25


-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu 
--almak için bir sorgu yazın.

select product_name, units_on_order, units_in_stock from products
where units_on_order > units_in_stock;

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.
select * from products
where lower(product_name) like 'a%';

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.
select * from products
where lower(product_name) like '%i';

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak 
--(ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name, unit_price, (unit_price + (unit_price * 0.18) ) as unit_price_kdv from products;

-- 10. Fiyatı 30 dan büyük kaç ürün var?
select count(*) from products
where unit_price > 30;


--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele

Select lower( product_name) , unit_price from products order by unit_price DESC

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır

Select (first_name , last_name) as Adsoyad  from employees


--13. Region alanı NULL olan kaç tedarikçim var?

Select Count(*) from suppliers where region  IS NULL


-- 14. a.Null olmayanlar?

Select Count(*) from suppliers where region  IS NOT NULL

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.

-- || yapmamızın sebebi postgresql de + olarak kullanıyoruz.

Select UPPER ( 'TR ' || product_name)from products    


--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select unit_price, ('TR' || product_name) from products where unit_price < 20

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select unit_price, product_name from products where unit_price = (select max(unit_price) from products)
select max(unit_price) from products

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select unit_price, product_name from products  order by unit_price desc limit 10

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products where unit_price > (select avg(unit_price) from products) order by unit_price desc

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select sum(units_in_stock * unit_price ) as totalPrice from products 

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select count(*) from products where units_in_stock > 0 and discontinued = 0


--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
select c.category_name, p.product_name from categories c 
join products p
on c.category_id = p.category_id;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select avg(unit_price), c.category_name
from categories as c 
join products as p
on c.category_id = p.category_id
group by category_name

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
Select  p.product_name, p.unit_price, c.category_name from products p
INNER JOIN categories c ON c. category_id = p.category_id
Where unit_price = (Select MAX (unit_price) from products);


--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
select s.company_name, c.category_name, product_name 
from categories as c
join products as p
on c.category_id = p.category_id
join suppliers as s
on s.supplier_id = p.supplier_id
order by units_on_order  desc
limit 1

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `PhONe`) 
--almak için bir sorgu yazın.

SELECT p.product_id, p.product_name, s.company_name, s.phone  
FROM products AS p
JOIN suppliers AS s 
ON p.supplier_id = s.supplier_id 
WHERE units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address, e.first_name || ' ' || e.last_name AS "Ad Soyad", order_date FROM orders AS o
JOIN employees AS e
ON e.employee_id = o.employee_id
WHERE order_date >= '1998-03-01' AND order_date <= '1998-03-31';

--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT count (*) FROM orders
WHERE DATE_PART('year', order_date) = 1997 AND DATE_PART('month',order_date) = 2;

--29. LONdON şehrinden 1998 yılında kaç siparişim var?
SELECT count (*) FROM orders 
WHERE ship_city = 'London' AND DATE_PART('year', order_date) = 1998;

--30. 1997 yılında sipariş veren müşterilerimin cONtactname ve telefON numarası
SELECT c.contact_name, c.phone, o.order_date  FROM orders AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE DATE_PART('year', order_date) = 1997
ORDER BY o.order_date;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT * FROM orders
WHERE freight > 40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_city, c.company_name, c.contact_name FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE o.freight > 40;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.order_date, o.ship_city, UPPER(e.first_name || ' ' || e.last_name) FROM orders AS o
JOIN employees AS e
ON o.employee_id = e.employee_id
WHERE DATE_PART('year', order_date) = 1997
ORDER BY order_date;

--34. 1997 yılında sipariş veren müşterilerin cONtactname i, ve telefON numaraları 
--( telefON formatı 2223322 gibi olmalı )
SELECT c.contact_name, regexp_replace(c.phone, '[^0-9]', '', 'g') FROM orders AS o
JOIN customers AS c
ON o.customer_id = c.customer_id
WHERE DATE_PART('year', order_date) = 1997
ORDER BY order_date;

--35. Sipariş tarihi, müşteri cONtact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.cONtact_name, e.first_name, e.last_name FROM orders AS o
JOIN customers AS c 
ON o.customer_id = c.customer_id
JOIN employees AS e 
ON e.employee_id = o.employee_id;

--36. Geciken siparişlerim?
SELECT * FROM orders
WHERE required_date < shipped_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.required_date AS "Geciken Tarih", c.company_name AS "Müşteri Adı" FROM orders AS o
JOIN customers AS c
ON c.customer_id = o.customer_id
WHERE required_date < shipped_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN categories AS c
ON p.category_id = c.category_id
WHERE od.order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.company_name FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN suppliers AS s
ON s.supplier_id = p.supplier_id
WHERE od.order_id = 10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT e.first_name, p.product_name, od.quantity FROM employees AS e
JOIN orders AS o
ON o.employee_id = e.employee_id
JOIN order_details AS od
ON o.order_id = od.order_id
JOIN products AS p
ON p.product_id = od.product_id
WHERE e.employee_id = 3 AND DATE_PART('year',o.order_date) = 1997;

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, e.first_name, e.last_name FROM orders AS o
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN employees AS e
ON e.employee_id = o.employee_id
WHERE od.quantity = (SELECT MAX(quantity) FROM order_details) AND DATE_PART('year', o.order_date) = 1997;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name, e.last_name, SUM(od.quantity) AS total_quantity FROM orders AS o
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN employees AS e
ON e.employee_id = o.employee_id
WHERE DATE_PART('year', o.order_date) = 1997
GROUP BY e.first_name,e.employee_id
ORDER BY total_quantity DESC Limit 1;


--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price ,c.category_name FROM products AS p
JOIN categories AS c
ON p.category_id = c.category_id
WHERE p.unit_price = (SELECT MAX(unit_price) FROM products);

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name, e.last_name,o.order_date,o.order_id FROM orders AS o
JOIN employees AS e
ON o.employee_id = e.employee_id
ORDER BY o.order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, AVG(od.unit_price) AS average_price
FROM order_details AS od
JOIN orders AS o
ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, (od.quantity * od.unit_price) AS "Toplam Satış Miktarı" FROM orders AS o
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN products AS p
ON od.product_id = p.product_id
JOIN categories AS c
ON p.category_id = c.category_id
WHERE DATE_PART('month',order_date) = 1;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT order_id,(quantity * unit_price) AS "Total Price", (SELECT AVG (unit_price*quantity) AS "Total Average" FROM order_details) FROM order_details
WHERE (quantity * unit_price) > (
    SELECT AVG(quantity * unit_price)
    FROM order_details
);


--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_id, p.product_name, c.category_name, s.company_name, od.quantity FROM order_details AS od
JOIN products AS p
on p.product_id = od.product_id
JOIN categories AS c
ON c.category_id = p.category_id
JOIN suppliers AS s
ON s.supplier_id = p.supplier_id
WHERE od.quantity = (SELECT MAX(quantity) FROM order_details)

--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT(ship_country)) FROM orders
GROUP BY ship_country

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?


SELECT e.first_name, SUM(od.quantity * od.unit_price)
FROM employees AS e
JOIN orders AS o ON o.employee_id = e.employee_id
JOIN order_details AS od ON o.order_id = od.order_id
WHERE e.employee_id = 3 AND o.order_date > (SELECT DATE_TRUNC('MONTH', CURRENT_DATE) - INTERVAL '1 month') AND o.order_date < CURRENT_DATE
GROUP BY e.first_name;




--51. Hangi ülkeden kaç müşterimiz var
SELECT o.ship_country, COUNT(DISTINCT(c.customer_id)) FROM orders AS o
INNER JOIN customers AS c
ON c.customer_id = o.customer_id
GROUP BY o.ship_country



--52. 10 numaralı ID ye sahip ürünümden sON 3 ayda ne kadarlık ciro sağladım?


SELECT o.order_date, SUM(od.quantity * od.unit_price) FROM products AS p
JOIN order_details AS od
ON od.product_id = p.product_id
JOIN orders AS o
ON o.order_id = od.order_id
WHERE p.product_id = 10
GROUP BY o.order_date
ORDER BY o.order_date DESC Limit 3



--53. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.employee_id ,COUNT(*) FROM orders AS o
JOIN employees AS e
ON e.employee_id = o.employee_id
GROUP BY e.employee_id

--54. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.customer_id,o.order_id FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL

--55. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name, contact_name, address, city FROM customers
WHERE country = 'Brazil'

--56. Brezilya’da olmayan müşteriler
SELECT company_name, contact_name, address, city, country FROM customers
WHERE country != 'Brazil'

--57. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT company_name, contact_name, address, city FROM customers
WHERE country='Spain' OR country = 'France' OR country='Germany'

--58. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers
WHERE fax IS NULL

--59. LONdra’da ya da Paris’de bulunan müşterilerim
SELECT company_name, contact_name, address, city FROM customers
WHERE city = 'London' OR city='Paris'

--60. Hem Mexico D.F’da ikamet eden HEM DE CONtactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers
WHERE city = 'México D.F.' AND contact_title = 'Owner'

--61. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price FROM products
WHERE product_name LIKE 'C%'

--62. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name, last_name, birth_date FROM employees
WHERE first_name LIKE 'A%'

--63. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers
WHERE UPPER(company_name) LIKE '%RESTAURANT%'

--64. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100

--65. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date FROM orders
WHERE DATE_PART('month',order_date) BETWEEN 7 AND  12 AND DATE_PART('year',order_date) = 1996


--66. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers
WHERE fax IS NULL

--67. Müşterilerimi ülkeye göre sıralıyorum:
SELECT * FROM customers 
ORDER BY country

--68. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sONuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC

--69. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sONuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC, units_in_stock ASC;

--70. 1 Numaralı kategoride kaç ürün vardır..?

select sum(units_in_stock) from products
where category_id = 1 

--71. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT(ship_country)) FROM orders
