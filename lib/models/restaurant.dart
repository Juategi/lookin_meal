
class Restaurant{
	String id, name, phone, website, webUrl, address, email, city, country;
	double latitude, longitude, rating;
	int numberViews;
	List<String> types, images;
	Map<String,List<int>> schedule;
	//Map<String,List<int>> schedule = {'1': new List<int>(), '2': new List<int>(), '3': new List<int>(), '4': new List<int>(), '5': new List<int>(), '6': new List<int>(), '0': new List<int>()};
	Restaurant({this.id,this.name,this.phone,this.website,this.webUrl,this.address,this.email,this.city,this.country,this.latitude,this.longitude,this.rating,this.numberViews,this.images,this.types,this.schedule});
}