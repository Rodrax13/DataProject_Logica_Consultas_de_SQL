/*DataProject:
LógicaConsultasSQL*/

/*1. Crea el esquema de la BBDD.*/

-- Adjunto Esquema en repositorio: Esquema_Cine.erd --

/*2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’.*/

select 
	f.title as titulo,
	f.rating as clasificacion
from film f 
where f.rating = 'R';


/*3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
y 40. */

select 
	concat (a.first_name ,' ', a.last_name ) as nombre_completo
from actor a 
where a.actor_id between 30 and 40;


/* 4. Obtén las películas cuyo idioma coincide con el idioma original. */

 select 
 	f.title as Titulo,
 	f.original_language_id as Idioma_Original,
 	f.language_id as Idioma
from film f 
where f.language_id = f.original_language_id ;


/* 5. Ordena las películas por duración de forma ascendente. */ 

select 
	f.title as Titulo,
	f.length as Duracion	
from film f 
order by f.length asc;


/* 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
apellido. */

select 
	a.first_name as Nombre,
	a.last_name  as Apellido
from actor a 
where a.last_name like '%ALLEN%';


/* 7. Encuentra la cantidad total de películas en cada clasificación de la tabla
“film” y muestra la clasificación junto con el recuento. */

select 
	f.rating as Clasificacion,
	count (*) as Cuenta_Peliculas
from film f
group by f.rating
order by count(*) desc ;


/* 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
duración mayor a 3 horas en la tabla film. */

select 
	f.title as Titulo,
	f.length as Duracion,
	f.rating  as clasificacion
from film f 
where f.rating = 'PG-13' or f.length > 180 ;


/* 9. Encuentra la variabilidad de lo que costaría reemplazar las películas. */

select 
 	round( max(f.replacement_cost),2) - round( min (f.replacement_cost),2) as variabilidad_coste
from film f ;


/* 10. Encuentra la mayor y menor duración de una película de nuestra BBDD. */

select 
	max (f.length) as maximo_duracion,
	min (f.length) as minimo_duracion
from film f ;


/* 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día. */

select 
	p.rental_id as antepenultimo_fecha,
	p.amount as Coste
from payment p 
where p.rental_id in (
	select 
		r.rental_id as antepenultimo
	from rental r 
	order by r.rental_date desc
	offset 2
	limit 1
);	


/****************** Query Alternativa ******************/

select
	p.rental_id as antepenultimo_fecha,
	p.amount as coste
from rental r 
inner join payment p 
	on r.rental_id = p.rental_id 
order by r.rental_date desc
offset 2
limit 1 ;



/* 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación. */

select 
	f.title as Titulo
from film f 
where f.rating <> 'NC-17' 
	and f.rating <> 'G';


/* 13. Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración. */

select 
	f.rating as Clasificacion,
	round (avg(f.length ),2)
from film f 
group by f.rating ;


/* 14. Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos. */

select 
	f.title as Titulo
from film f 
where f.length > 180;


/* 15. ¿Cuánto dinero ha generado en total la empresa? */

select 
	sum(p.amount ) as Ingresos_Totales
from payment p ;


/* 16. Muestra los 10 clientes con mayor valor de id. */

select * 	
from customer c 
order by c.customer_id desc
limit 10;

/* 17. Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igby’.*/

select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
where a.actor_id in (
	select 
		fa.actor_id  
	from film_actor fa 
	where fa.film_id in (
		select 
			f.film_id 
		from film f 
		where f.title = 'EGG IGBY'
	)
);


/* DataProject: LógicaConsultasSQL 2 */


/* 18. Selecciona todos los nombres de las películas únicos.*/

select distinct 
	f.title as titulo
from film f ;


/* 19. Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “film”.*/

select 
	f.title as Titulo
from film f 
	left join film_category fc 
		on f.film_id = fc.film_id 
	left join category c 
		on fc.category_id = c.category_id 
where name = 'Comedy' 
and f.length > 180;		
	

/* 20. Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración. */

select
	c."name" ,
	round( avg(f.length ),2)
from film f 
	left join film_category fc 
		on f.film_id = fc.film_id 
	left join category c 
		on fc.category_id = c.category_id 
group by "name" 	
having round (avg(f.length ),2) > 110;


/* 21. ¿Cuál es la media de duración del alquiler de las películas? */

select 
	avg(r.return_date - r.rental_date) as media_duracion
from rental r ;



/* 22. Crea una columna con el nombre y apellidos de todos los actores y
actrices. */

select 
	concat( a.first_name , ' ', a.last_name ) as nombre_Apellido
from actor a ;



/* 23. Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente. */

select 
	date(r.rental_date ) as fecha,
	count(r.rental_date ) as cantidad_alquiler
from rental r 
group by date(r.rental_date)
order by count (r.rental_date ) desc;



/* 24. Encuentra las películas con una duración superior al promedio. */

select 
  	f.title  as titulo,
  	f.length  as duracion
from film f 
where 
	f.length > (
	select
		AVG(f.length )
	from film f 	
);



/* 25. Averigua el número de alquileres registrados por mes. */

select 
	extract(month from r.rental_date ) as mes,
	count(*) as total_alquileres
from rental r 
group by extract(month from r.rental_date );


/* 26. Encuentra el promedio, la desviación estándar y varianza del total
pagado. */

select 
	round(avg(amount),2) as promedio_pagado,
	round(stddev (p.amount),2) as desviacion_estandar_pagado,
	round(variance(amount),2) as varianza_pagado
from payment p ;


/* 27. ¿Qué películas se alquilan por encima del precio medio? */

select 
	f.title  as titulo_sup_avg_precio
from payment p 
left join rental r 
	on p.rental_id = r.rental_id 
left join inventory i 
	on r.inventory_id = i.inventory_id 
left join film f 
	on i.film_id = f.film_id 
where p.amount > (
	select avg(p.amount)
	from payment p ) ;



/* 28. Muestra el id de los actores que hayan participado en más de 40
películas. */

select 
	fa.actor_id as id_actor_sup_40peliculas
from film_actor fa 
group by fa.actor_id 
having count(fa.actor_id ) > 40;

/* 29. Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible. */


select 
	f.title as titulo,
	count(i.inventory_id ) as disponibles
from film f 
left join inventory i 
	on f.film_id  = i.film_id 
group by titulo 
order by disponibles desc;



/* 30. Obtener los actores y el número de películas en las que ha actuado. */

select 
	a.first_name as nombre,
	a.last_name as apellido,
	count(a.actor_id ) as numero_peliculas
from actor a 
left join film_actor fa 
	on a.actor_id = fa.actor_id 
left join film f 
	on fa.film_id  = f.film_id 
group by a.actor_id 	
order by numero_peliculas desc;


/* 31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados. */

select 
	f.title as titulo,
	a.first_name as nombre,
	a.last_name as apellido
from film f 
left join film_actor fa 
	on f.film_id  = fa.film_id 
left join actor a 
	on fa.actor_id = a.actor_id 
order by f.title asc;	


/* 32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película. */

select 
	a.first_name as nombre,
	a.last_name as apellido,
	f.title as titulo
from actor a
left join film_actor fa 
	on a.actor_id = fa.actor_id 
left join film f 
	on fa.film_id  = f.film_id  
order by a.actor_id  asc;	

/* 33. Obtener todas las películas que tenemos y todos los registros de
alquiler. */

select 
	f.title as titulo,
	count(r.rental_date  ) as alquileres
from film f 
inner join inventory i 
	on f.film_id = i.film_id 
left join rental r 
	on i.inventory_id = r.inventory_id 
group by titulo 
order by alquileres desc;



/* 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros. */

select 
	c.customer_id as id,
	c.first_name as nombre,
	c.last_name as apellido,
	c.email as email
from customer c 
where c.customer_id in (
	select 
		p.customer_id
	from payment p 
	group by customer_id
	order by sum(p.amount ) desc
	limit 5
);


/* 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.*/

select 
	*
from actor a 
where a.first_name = 'JOHNNY';


/* 36. Renombra la columna “first_name” como Nombre y “last_name” como
Apellido. */

select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a ;


/* DataProject: LógicaConsultasSQL 3 */

/* 37. Encuentra el ID del actor más bajo y más alto en la tabla actor. */

select 
	min(a.actor_id ) as mas_bajo,
	max(a.actor_id ) as mas_alto
from actor a ;


/*/ 38. Cuenta cuántos actores hay en la tabla “actor”. */

select 
	count(a.actor_id ) as cuenta_actores
from actor a ;


/* 39. Selecciona todos los actores y ordénalos por apellido en orden
ascendente. */

select *
from actor a 
order by a.last_name asc ;

/* 40. Selecciona las primeras 5 películas de la tabla “film”. */

select *
from film f 
order by f.film_id asc
limit 5 ;


/* 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido? */

select 
	a.first_name as nombre,
	count(a.first_name ) as repetido
from actor a 
group by a.first_name 
order by repetido desc ;


/* 42. Encuentra todos los alquileres y los nombres de los clientes que los
realizaron. */

select 
	r.rental_date as fecha_alquiler,
	r.return_date as fecha_devolucion,
	c.first_name as nombre,
	c.last_name as apellido
from rental r 
inner join customer c 
	on r.customer_id = c.customer_id ;


/* 43. Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres. */

select 
	c.first_name as nombre,
	c.last_name as apellido,
	r.rental_date as fecha_alquiler,
	r.return_date as fecha_devolucion
from customer c 
left join rental r 
	on c.customer_id = r.customer_id ;


/* 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación. */

select *
from film f 
cross join category c ;

/* No aporta valor ya que no hay ningun campo comun PK / FK entre estas tablas por lo que ejecuta una combinación sin sentido de cada pelicula por cada categoria, 
  al ser una relación de M:M se requiere de una tabla intermedia ya existente 'film_category' que si refleja la relación real entre ambas */


/* 45. Encuentra los actores que han participado en películas de la categoría
'Action'. */

select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
inner join film_actor fa 
	on a.actor_id = fa.actor_id 
inner join film f 
	on fa.film_id = f.film_id 
inner join film_category fc 
	on f.film_id = fc.film_id
inner join category c 
	on fc.category_id = c.category_id 
where c."name" = 'Action' ;	


/* 46. Encuentra todos los actores que no han participado en películas. */

select *
from actor a 
left join film_actor fa 
	on a.actor_id = fa.actor_id
where fa.film_id is null;

/* 47. Selecciona el nombre de los actores y la cantidad de películas en las
que han participado. */

select 
	a.first_name as nombre,
	count(a.actor_id ) as cantidad_peliculas
from actor a 
left join film_actor fa 
	on a.actor_id = fa.actor_id
group by a.actor_id 
order by cantidad_peliculas desc ;


/* 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
de los actores y el número de películas en las que han participado. */

create view actor_num_peliculas as 
select 
	a.first_name as nombre,
	count(a.actor_id ) as cantidad_peliculas
from actor a 
left join film_actor fa 
	on a.actor_id = fa.actor_id
group by a.actor_id 
order by cantidad_peliculas desc ;


/* 49. Calcula el número total de alquileres realizados por cada cliente. */

select 
	r.customer_id as id,
	c.first_name as nombre,
	c.last_name as apellido,
	count(r.customer_id ) as total_alquileres
from customer c 
inner join rental r 
	on c.customer_id = r.customer_id 
group by r.customer_id , c.first_name , c.last_name 
order by total_alquileres desc ;


/* 50. Calcula la duración total de las películas en la categoría 'Action'. */

select 
	sum(f.length ) as duracion_total_action
from film f 
inner join film_category fc 
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
where c."name" = 'Action' ;		
			

/* 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
almacenar el total de alquileres por cliente. */

with cliente_rentas_temporal as(
	select 
		c.customer_id as identificador,
		c.first_name as nombre,
		c.last_name as apellido,
	count (r.rental_date ) as total_alquileres
	from customer c 
	inner join rental r 
		on c.customer_id = r.customer_id 
	group by c.customer_id 
)
select *
from cliente_rentas_temporal ;

	
/* 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces. */

with peliculas_alquiladas as(
	select 
		f.title as titulo,
		count (r.rental_date) as alquileres
	from film f 
	inner join inventory i 
		on f.film_id = i.film_id 
	inner join rental r 
		on i.inventory_id = r.inventory_id 
	group by f.title 		
	having count (r.rental_date) > 10
	order by alquileres desc 
)
select *
from peliculas_alquiladas ;


/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película. */

select 
	f.title as titulos_no_devueltos
from film f 
inner join inventory i 
	on f.film_id = i.film_id 
inner join rental r 
	on i.inventory_id = r.inventory_id 
inner join customer c 
	on r.customer_id = c.customer_id 
where concat(c.first_name , ' ', c.last_name ) = 'TAMMY SANDERS'
	and r.return_date is null
order by f.title asc;	
	

/* 54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido. */

select 
	a.first_name as nombre,
	a.last_name ,
	count(f.film_id ) as Cuenta_scifi
from actor a 
inner join film_actor fa 
	on a.actor_id = fa.actor_id 
inner join film f 
	on fa.film_id = f.film_id 
inner join film_category fc 
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
where c."name" = 'Sci-Fi'
group by a.actor_id ,a.first_name, a.last_name 
order by a.last_name asc ;


/* DataProject: LógicaConsultasSQL 4 */

/* 55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido. */

select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
inner join film_actor fa 
	on a.actor_id = fa.actor_id 
inner join film f 
	on fa.film_id = f.film_id 
inner join inventory i 
	on f.film_id = i.film_id 
inner join rental r 
	on i.inventory_id = r.inventory_id 
where r.rental_date > (
	select 
		r.return_date as primer_alquiler
	from rental r 
		inner join inventory i 
			on r.inventory_id = i.inventory_id 
		where i.film_id = ( 
			select 
				f.film_id 
			from film f 
			where f.title = 'SPARTACUS CHEAPER'
		)	
	order by r.rental_date asc
	limit 1
)
group by a.first_name, a.last_name 
order by a.last_name asc;


/* 56. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’. */

select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
inner join film_actor fa 
	on a.actor_id = fa.actor_id 
inner join film f 
	on fa.film_id = f.film_id 
inner join film_category fc 
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
where c."name" <> 'Music'	
group by a.first_name , a.last_name ;


/****************** Query Corregida ******************/


select 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
where a.actor_id not in (
	select 
	a.actor_id as id
	from actor a 
		inner join film_actor fa 
			on a.actor_id = fa.actor_id 
		inner join film f 
			on fa.film_id = f.film_id 
		inner join film_category fc 
			on f.film_id = fc.film_id 
		inner join category c 
			on fc.category_id = c.category_id
		where c."name"  = 'Music'	
);



/* 57. Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días. */

select 
	f.title as titulo_alq_sup_8
from film f 
inner join inventory i 
	on f.film_id = i.film_id 
inner join rental r 
	on i.inventory_id = r.inventory_id 
where ( date(r.return_date) - date(r.rental_date) )	> 8 ;



/* 58. Encuentra el título de todas las películas que son de la misma categoría
que ‘Animation’. */

select 
	f.title as titulo
from film f 
inner join film_category fc 
	on f.film_id = fc.film_id 
inner join category c 
	on fc.category_id = c.category_id 
where c."name" = 'Animation'
group by f.title ;


/* 59. Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película. */

select 
	f.title as titulo
from film f 
where f.length = (
	select 
		f.length as duracion
	from film f
	where f.title = 'DANCING FEVER'
)
order by titulo ;


/* 60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido.*/

select 
	c.first_name as nombre,
	c.last_name as apellido,
	count(distinct f.film_id ) as alquileres_distintos
from customer c 
	inner join rental r 
		on c.customer_id = r.customer_id 
	inner join inventory i 
		on r.inventory_id = i.inventory_id 
	inner join film f 
		on i.film_id = f.film_id 
group by c.customer_id 						
order by c.last_name ;


/* 61. Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres. */

select
	c."name" as categoria,
	count(r.rental_id ) as recuento_alquileres
from rental r 
	inner join inventory i 
		on r.inventory_id = i.inventory_id 
	inner join film f 
		on i.film_id = f.film_id 
	inner join film_category fc 
		on f.film_id = fc.film_id 
	inner join category c 
		on fc.category_id = c.category_id 
group by categoria 	;


/* 62. Encuentra el número de películas por categoría estrenadas en 2006. */

select 
	c."name" as categoria,
	count(*)
from film f 
	inner join film_category fc 
		on f.film_id = fc.film_id 
	inner join category c 
		on fc.category_id = c.category_id 
where f.release_year = 2006 
group by categoria ;


/*/ 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos. */

select *
from staff s 
	cross join store s2 ;

/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas. */

with cliente_rentas_temporal as(
	select 
		c.customer_id as identificador,
		c.first_name as nombre,
		c.last_name as apellido,
	count (r.rental_date ) as total_alquileres
	from customer c 
	inner join rental r 
		on c.customer_id = r.customer_id 
	group by c.customer_id 
)
select 
	concat(identificador , ' ', nombre, ' ', apellido, ' ', total_alquileres) as conjunto
from cliente_rentas_temporal ;


/* Gracias por el aprendizaje! */





