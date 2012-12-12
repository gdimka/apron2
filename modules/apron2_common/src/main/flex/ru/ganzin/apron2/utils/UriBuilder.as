/**
 * Created by IntelliJ IDEA.
 * User: Dmitriy Ganzin
 * Date: 29.05.12
 * Time: 15:40
 */
package ru.ganzin.apron2.utils {

	import com.adobe.net.URI;

	public class UriBuilder {

		private var _uri : URI;

		public function UriBuilder(uri : *) {
			if (uri is URI) _uri = uri;
			else _uri = new URI(String(uri));
		}

		public function setScheme(schemeStr : String) : UriBuilder {
			_uri.scheme = schemeStr;
			return this;
		}

		public function setAuthority(authorityStr : String) : UriBuilder {
			_uri.authority = authorityStr;
			return this;
		}

		public function setUsername(usernameStr : String) : UriBuilder {
			_uri.username = usernameStr;
			return this;
		}

		public function setPassword(passwordStr : String) : UriBuilder {
			_uri.password = passwordStr;
			return this;
		}

		public function setPort(portStr : String) : UriBuilder {
			_uri.port = portStr;
			return this;
		}

		public function setPath(pathStr : String) : UriBuilder {
			_uri.path = pathStr;
			return this;
		}

		public function setQuery(queryStr : String) : UriBuilder {
			_uri.query = queryStr;
			return this;
		}

		public function setQueryRaw(queryStr : String) : UriBuilder {
			_uri.queryRaw = queryStr;
			return this;
		}

		public function chdir(reference : String, escape : Boolean = false) : UriBuilder {
			_uri.chdir(reference, escape);
			return this;
		}

		public function get uri() : URI {
			return _uri;
		}

		public function toString() : String {
			return _uri.toString();
		}
	}
}
