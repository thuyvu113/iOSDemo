
interface UserInfo {
	id: string;
	email: string;
	password: string;
	firstname: string;
	lastname: string;
}

interface Genre {
	id: number;
	genre: string
}

interface Movie {
	id: string;
	title: string;
	duration: number;
	imdb: number;
	genres: string[];
	poster: string;
	cover: string;
}

interface Location {
	id: string;
	name: string;
	showTimes: number[];
}

interface APIResponse {
	status: number;
	data: any;
}

export class RequestHandler {

	getAllLocations(db: any): Promise<any> {
		const docRef = db.collection("locations");

		let response: APIResponse  = {
										status: 0,
										data: null
									};
		return docRef.get().then(snapshot => {
			const results: Location[] = [];
            snapshot.forEach(doc => {
            	const location: Location = {
            		id: doc.id,
            		name: doc.data().name,
            		showTimes: doc.data().show_times 
            	}
            	
            	results.push(location);
            })

            response = {
            	status: 1,
            	data: results
            };
            
            return response;
        });
	}

	getAllGenres(db: any): Promise<any> {
		const docRef = db.collection("genres");

		let response: APIResponse  = {
										status: 0,
										data: null
									};
		return docRef.get().then(snapshot => {
			const results: Genre[] = [];
            snapshot.forEach(doc => {
            	const genre: Genre = {
            		id: doc.id,
            		genre: doc.data().genre,
            	}
            	
            	results.push(genre);
            })

            response = {
            	status: 1,
            	data: results
            };
            
            return response;
        });
	}

	getMovies(db: any, params: any): Promise<any> {
		const genre = String(params["genre"]);
		let docRef = db.collection("movies");
		if (genre != '0') {
			docRef = db.collection("movies").where("genres", "array-contains", genre);
		}

		let response: APIResponse  = {
										status: 0,
										data: null
									};
		return docRef.get().then(snapshot => {
			const results: Movie[] = [];
            snapshot.forEach(doc => {
            	const movie: Movie = {
            		id: doc.id,
            		title: doc.data().title,
					duration: doc.data().duration,
					imdb: doc.data().imdb,
					genres: doc.data().genres,
					poster: doc.data().poster,
					cover: doc.data().cover
            	}
            	
            	results.push(movie);
            })

            response = {
            	status: 1,
            	data: results
            };
            
            return response;
        });
	}

	login(db: any, data: any): Promise<any> {
		const docRef = db.collection("users");
		const queryRef = docRef.where("email", "==", data["email"]);

		let response: APIResponse  = {
										status: 0,
										data: null
									};
		return queryRef.get().then(snapshot => {
			let results: UserInfo[] = [];
			snapshot.forEach(doc => {
				const userInfo = {
					id: doc.id,
					email: doc.data().email,
					password: doc.data().password,
					firstname: doc.data().firstname,
					lastname: doc.data().lastname
				}
				results.push(userInfo);
			})

			if (results.length === 1) {
				const user = results[0];
				if (user.password === data["password"]) {
					delete user.password
					response = {
						status: 1,
						data: user
					};
				} 
			}
			
			return response;
		});
	}
}