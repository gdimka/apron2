package ru.ganzin.apron2.utils
{
	import flash.utils.Dictionary;

	import ru.ganzin.apron2.collections.IMap;

	/**********************************************************************************************************/
	public class StringUtil
	{
		/**
		 * Добавляет к концу строки sString символы sChars копируя их nCount раз.
		 * @param sString Входящая строка
		 * @param sChars Добавляемые символы добавить
		 * @param nCount Количество раз
		 * @return Результирующая строка
		 */
		public static function addCharsToRight(sString:String,sChars:String,nCount:Number):String
		{
			for (var i:int = 0;i < nCount;i++) sString += sChars;
			return sString;
		}

		/**
		 * Добавляет к началу строки sString символы sChars копируя их nCount раз.
		 * @param sString Входящая строка
		 * @param sChars Добавляемые символы добавить
		 * @param nCount Количество раз
		 * @return Результирующая строка
		 */
		public static function addCharsToLeft(sString:String,sChars:String,nCount:Number):String
		{
			for (var i:int = 0;i < nCount;i++) sString = sChars + sString;
			return sString;
		}

		/**
		 * Проверяет является ли эта строка sString числом.
		 * @param sString Входящая строка
		 * @return True/False
		 */
		public static function isNumber(sString:String):Boolean
		{
			return (Number(sString).toString() == sString) ? true : false;
		}

		/**
		 * Ищет в строке sString строку sWhat и заменяет её на sTo.
		 * @param sString Входящая строка
		 * @param sWhat Что ищим
		 * @param sTo На что заменяем
		 * @return Результирующая строка
		 */
		public static function replace(sString:String, sWhat:String, sTo:String):String
		{
			return String(sString.split(sWhat).join(sTo));
		}

		/**
		 * Ищет в строке sString все строки sWhat и заменяет её на sTo.
		 * @param sString Входящая строка
		 * @param sWhat Что ищим
		 * @param sTo На что заменяем
		 * @return Результирующая строка
		 */
		public static function replaceAll(sString:String, sWhat:String, sTo:String):String
		{
			sString = String(sString.split(sWhat).join(sTo));
			if (sString.indexOf(sWhat) != -1) return replaceAll(sString, sWhat, sTo);
			return sString;
		}

		/**
		 * Удаляет с начала и конца строки sString симолы новой строки, табуляции и пробелы.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function trim(sString:String):String
		{
			return leftTrim(rightTrim(sString));
		}

		/**
		 * Удаляет с начала строки sString симолы новой строки, табуляции и пробелы.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function leftTrim(sString:String):String
		{
			return leftTrimForChars(sString, "\n\t\n " + unescape("%0D%0A"));
		}

		/**
		 * Удаляет с конца строки sString симолы новой строки, табуляции и пробелы.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function rightTrim(sString:String):String
		{
			return rightTrimForChars(sString, "\n\t\n " + unescape("%0D%0A"));
		}

		/**
		 * Удаляет с начала строки sString символы списка sChars.
		 * @param sString Входящая строка
		 * @param sChars Список символов
		 * @return Результирующая строка
		 */
		public static function leftTrimForChars(sString:String, sChars:String):String
		{
			var nFrom:Number = 0;
			var nTo:Number = sString.length;
			while (nFrom < nTo && sChars.indexOf(sString.charAt(nFrom)) >= 0) nFrom++;
			return String((nFrom > 0 ? sString.substr(nFrom, nTo) : sString));
		}

		/**
		 * Удаляет с конца строки sString символы списка sChars.
		 * @param sString Входящая строка
		 * @param sChars Список символов
		 * @return Результирующая строка
		 */
		public static function rightTrimForChars(sString:String, sChars:String):String
		{
			var nFrom:Number = 0;
			var nTo:Number = sString.length - 1;
			while (nFrom < nTo && sChars.indexOf(sString.charAt(nTo)) >= 0) nTo--;
			return String((nTo >= 0 ? sString.substr(nFrom, nTo + 1) : sString));
		}

		/**
		 * Проверяет, является ли строка sString электронным адресом.
		 * @param sEmail Электронный адрес
		 * @return True/False
		 */
		public static function checkEmail(sEmail:String):Boolean
		{
			if (sEmail.length < 6) return false;
			if (sEmail.split('@').length > 2 || sEmail.indexOf('@') < 0) return false;
			if (sEmail.lastIndexOf('@') > sEmail.lastIndexOf('.')) return false;
			if (sEmail.lastIndexOf('.') > sEmail.length - 3) return false;
			if (sEmail.lastIndexOf('.') <= sEmail.lastIndexOf('@') + 1) return false;
			return true;
		}

		/**
		 * Заверяет, что длинна строки больше или равна заданной длинне.
		 * @param sString Входящая строка
		 * @param nLength Длнна строки
		 * @return True/False
		 */
		public static function assureLength(sString:String, nLength:Number):Boolean
		{
			if (nLength < 0 || (!nLength && nLength !== 0)) return (sString.length >= nLength);
			return false;
		}

		/**
		 * Определяет, начинается ли данная строка sString с sSearchString.
		 * @param sString Входящая строка
		 * @param sSearchString Вероятное начало строки
		 * @return True/False
		 */
		public static function startsWith(sString:String, sSearchString:String):Boolean
		{
			if (sString.indexOf(sSearchString) == 0) return true;
			return false;
		}

		/**
		 * Определяет, заканчивается ли данная строка на sSearchString.
		 * @param sString Входящая строка
		 * @param sSearchString Вероятный конец строки
		 * @return True/False
		 */
		public static function endsWith(sString:String, sSearchString:String):Boolean
		{
			if (sString.lastIndexOf(sSearchString) == (sString.length - sSearchString.length)) return true;
			return false;
		}

		/**
		 * Добавляет пробельный отступ в переданую строку. Этот метод полезен для разнообразных строк типа ASCII.
		 * Он создает динамический размер пробельного отступа перед каждой новой линией строки.
		 * <br><br>Пример:
		 * <br>var bigText = "My name is pretty important\n" + "because i am a interesting\n" + "small example for this\n" + "documentation.";
		 * <br>var result = StringUtil.addSpaceIndent(bigText, 3);
		 * <br><br>Содержание переменной result (звёздочка, как пробел):
		 *
		 * <p>My name is pretty important</p>
		 * <p>***because i am a interesting</p>
		 * <p>***small example for this</p>
		 * <p>***documentation.</p>
		 *
		 * @param sString Входящая строка
		 * @param nSize Длинна отступа
		 * @return Результирующая строка
		 */
		public static function addSpaceIndent(sString:String, nSize:Number):String
		{
			if (sString == null) sString = "";
			if (nSize < 0) return String("");
			var sIndentString:String = multiply(" ", nSize);
			return sIndentString + replace(sString, "\n", "\n" + sIndentString);
		}

		/**
		 * Перемножает строку sString в nFactor, создает длинную строку.
		 * <br><br>Пример: trace("Result: "+StringUtil.multiply(">", 6);
		 * <br><br>Результат в Output панеле: >>>>>>>
		 *
		 * @param sString Входящая строка
		 * @param nFactor Количество перемножений
		 * @return Результирующая строка
		 */
		public static function multiply(sString:String, nFactor:Number):String
		{
			var sResult:String = "";
			for (var i:int = nFactor;i > 0; i--) sResult += sString;
			return sResult;
		}

		/**
		 * Делает первый символ строки заглавным.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function ucFirst(sString:String):String
		{
			return String(sString.charAt(0).toUpperCase() + sString.substr(1));
		}

		/**
		 * Делает первый символ каждого слова заглавным.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function ucWords(sString:String):String
		{
			var aW:Array = sString.split(" ");
			var nL:Number = aW.length;
			for (var i:Number = 0;i < nL; i++) aW[i] = StringUtil.ucFirst(aW[i]);
			return String(aW.join(" "));
		}

		/**
		 * Выкидывает первый символ строки.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function firstChar(sString:String):String
		{
			return String(sString.charAt(0));
		}

		/**
		 * Выкидывает последний символ строки.
		 * @param sString Входящая строка
		 * @return Результирующая строка
		 */
		public static function lastChar(sString:String):String
		{
			return String(sString.charAt(sString.length - 1));
		}

		/**
		 * Конфертирует строку в Boolean.
		 * @param value Входящая строка
		 * @return True/False
		 */
		public static function toBoolean(value:String):Boolean
		{
			if (value == "1" || value == "true") return true;
		else return false;
		}

		/**
		 * Конфертирует строку в Number.
		 * @param value Входящая строка
		 * @return число
		 */
		public static function toNumber(value:String):Number
		{
			var nInt:Number = parseInt(value);
			var nFloat:Number = parseFloat(value);
			if (value == nInt.toString()) return nInt;
			else if (value == nFloat.toString()) return nFloat;
			return Number.NaN;
		}
		
		/**
		 * Конвертирует строку в массив.
		 * @param sString Входящая строка
		 * @param sDelimeters Разделитель
		 * @param bTrim Обрезать строки после?
		 * @param bIgnoreEmpty Игнорировать пустые строки?
		 * @return массив
		 */
		public static function toArray(sString:String,sDelimeters:String,bTrim:Boolean = true, bIgnoreEmpty:Boolean = true):Array
		{
			var aList:Array = new Array();
			var aDelimeters:Array = sDelimeters.split("");
			var nLastDelimPos:int = -1;
			for (var i:int = 0;i <= sString.length;i++)
			{
				for (var j:int = 0;j < aDelimeters.length;j++)
				{
					if (sString.substr(i, 1) == aDelimeters[j] || (j == aDelimeters.length - 1 && i == sString.length))
					{
						var sItem:String = String(sString.slice(nLastDelimPos + 1, i));
						if (bTrim) sItem = StringUtil.trim(sItem);
						if (!(bIgnoreEmpty && sItem.length == 0)) aList.push(sItem);
						nLastDelimPos = i;
						break;
					}
				}
			}
			return aList;
		}

		/**
		 * Конвертирует строку в строго типизированный массив.
		 * @param sString Входящая строка
		 * @param sDelimeters Разделитель
		 * @param fType Функция конвертирования строки в данные
		 * @param bTrim Обрезать строки после?
		 * @param bIgnoreEmpty Игнорировать пустые строки?
		 * @return строго типизированный массив
		 */
		public static function toTypedArray(sString:String, sDelimeters:String, fType:Function, bTrim:Boolean = true, bIgnoreEmpty:Boolean = true):Array
		{
			var aList:Array = toArray(sString, sDelimeters, bTrim, bIgnoreEmpty);
			for (var i:int = 0;i < aList.length;i++)
			{
				aList[i] = fType(aList[i]);
			}
			return aList;
		}

		/**
		 *  Substitutes "{n}" tokens within the specified string
		 *  with the respective arguments passed in.
		 *
		 *  @param str The string to make substitutions in.
		 *  This string can contain special tokens of the form
		 *  <code>{n}</code>, where <code>n</code> is a zero based index,
		 *  that will be replaced with the additional parameters
		 *  found at that index if specified.
		 *
		 *  @param rest Additional parameters that can be substituted
		 *  in the <code>str</code> parameter at each <code>{n}</code>
		 *  location, where <code>n</code> is an integer (zero based)
		 *  index value into the array of values specified.
		 *  If the first parameter is an array this array will be used as
		 *  a parameter list.
		 *  This allows reuse of this routine in other methods that want to
		 *  use the ... rest signature.
		 *  For example <pre>
		 *     public function myTracer(str:String, ... rest):void
		 *     {
		 *         label.text += StringUtil.substitute(str, rest) + "\n";
		 *     } </pre>
		 *
		 *  @return New string with all of the <code>{n}</code> tokens
		 *  replaced with the respective arguments specified.
		 *
		 *  @example
		 *
		 *  var str:String = "here is some info '{0}' and {1}";
		 *  trace(StringUtil.substitute(str, 15.4, true));
		 *
		 *  // this will output the following string:
		 *  // "here is some info '15.4' and true"
		 */
		 
		private static const SUBSTITUDE_REGEXP:RegExp = /.*?\{(.*?)\}/g;
		 
		public static function substitute(str:String, ... rest):String
		{
			if (str == null) return '';

			var retStr:String = str;
			var args:Array;
			var argsMap:Object;
			var i:int;
			var key:*;
			var value:*;

			if (rest.length == 1 && !ObjectUtil.isPrimitiveType(rest[0])) argsMap = rest[0];
        	else args = rest;
			
			var map:IMap = rest[0] as IMap;
			var dict:Dictionary = rest[0] as Dictionary;
			var arr:Array = rest[0] as Array;
			
			if (args)
			{
				for (i=0;i<args.length;i++)
					retStr = retStr.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			else if (argsMap)
			{			
				var result:Object;
				while(result = SUBSTITUDE_REGEXP.exec(str))
				{
					key = result[1];
					if (map) value = map.getValue(key);
					else if (dict && dict[key]) value = dict[key];
					else if (arr)
					{
						key = int(key);
						if (key != null) value = arr[key];
					}
					else if (!ObjectUtil.isPrimitiveType(rest[0])) value = rest[0][key];
					
					key = key.toString();
					if (key && value != undefined) retStr = retStr.replace(new RegExp("\\{" + key + "\\}", "g"), value);
				}
			}
			
			return retStr;
		}

		public static function getDomainUrl(url:String):String
		{
			return String(url.match(new RegExp("^([a-zA-Z]+:\/\/)?([^\/]+)\/.*?", "ig"))[0]);
		}

		public static function isLocalFile(url:String):Boolean
		{
			return ( url.indexOf("file://") != -1 );
		}
		
		public static function isRegexp(value:String):Boolean
		{
			var reg:RegExp = /^\/.*\/[gismx]*$/i;
			return reg.test(value);
		}
		
		/**
		*	Returns everything after the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function afterFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		*	Returns everything after the last occurence of the provided character in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function afterLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
			if (idx == -1) { return ''; }
			idx += p_char.length;
			return p_string.substr(idx);
		}

		/**
		*	Determines whether the specified string begins with the specified prefix.
		*
		*	@param p_string The string that the prefix will be checked against.
		*
		*	@param p_begin The prefix that will be tested against the string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beginsWith(p_string:String, p_begin:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_begin) == 0;
		}

		/**
		*	Returns everything before the first occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beforeFirst(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.indexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}

		/**
		*	Returns everything before the last occurrence of the provided character in the string.
		*
		*	@param p_string The string.
		*
		*	@param p_begin The character or sub-string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function beforeLast(p_string:String, p_char:String):String {
			if (p_string == null) { return ''; }
			var idx:int = p_string.lastIndexOf(p_char);
        	if (idx == -1) { return ''; }
        	return p_string.substr(0, idx);
		}

		/**
		*	Returns everything after the first occurance of p_start and before
		*	the first occurrence of p_end in p_string.
		*
		*	@param p_string The string.
		*
		*	@param p_start The character or sub-string to use as the start index.
		*
		*	@param p_end The character or sub-string to use as the end index.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function between(p_string:String, p_start:String, p_end:String):String {
			var str:String = '';
			if (p_string == null) { return str; }
			var startIdx:int = p_string.indexOf(p_start);
			if (startIdx != -1) {
				startIdx += p_start.length; // RM: should we support multiple chars? (or ++startIdx);
				var endIdx:int = p_string.indexOf(p_end, startIdx);
				if (endIdx != -1) { str = p_string.substr(startIdx, endIdx-startIdx); }
			}
			return str;
		}

		/**
		*	Description, Utility method that intelligently breaks up your string,
		*	allowing you to create blocks of readable text.
		*	This method returns you the closest possible match to the p_delim paramater,
		*	while keeping the text length within the p_len paramter.
		*	If a match can't be found in your specified length an  '...' is added to that block,
		*	and the blocking continues untill all the text is broken apart.
		*
		*	@param p_string The string to break up.
		*
		*	@param p_len Maximum length of each block of text.
		*
		*	@param p_delim delimter to end text blocks on, default = '.'
		*
		*	@returns Array
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function block(p_string:String, p_len:uint, p_delim:String = "."):Array {
			var arr:Array = new Array();
			if (p_string == null || !contains(p_string, p_delim)) { return arr; }
			var chrIndex:uint = 0;
			var strLen:uint = p_string.length;
			var replPatt:RegExp = new RegExp("[^"+escapePattern(p_delim)+"]+$");
			while (chrIndex <  strLen) {
				var subString:String = p_string.substr(chrIndex, p_len);
				if (!contains(subString, p_delim)){
					arr.push(truncate(subString, subString.length));
					chrIndex += subString.length;
				}
				subString = subString.replace(replPatt, '');
				arr.push(subString);
				chrIndex += subString.length;
			}
			return arr;
		}

		/**
		*	Capitallizes the first word in a string or all words..
		*
		*	@param p_string The string.
		*
		*	@param p_all (optional) Boolean value indicating if we should
		*	capitalize all words or only the first.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function capitalize(p_string:String, ...args):String {
			var str:String = trimLeft(p_string);
			trace('capl', args[0])
			if (args[0] === true) { return str.replace(/^.|\b./g, _upperCase);}
			else { return str.replace(/(^\w)/, _upperCase); }
		}

		/**
		*	Determines whether the specified string contains any instances of p_char.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string we are looking for.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function contains(p_string:String, p_char:String):Boolean {
			if (p_string == null) { return false; }
			return p_string.indexOf(p_char) != -1;
		}

		/**
		*	Determines the number of times a charactor or sub-string appears within the string.
		*
		*	@param p_string The string.
		*
		*	@param p_char The character or sub-string to count.
		*
		*	@param p_caseSensitive (optional, default is true) A boolean flag to indicate if the
		*	search is case sensitive.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function countOf(p_string:String, p_char:String, p_caseSensitive:Boolean = true):uint {
			if (p_string == null) { return 0; }
			var char:String = escapePattern(p_char);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.match(new RegExp(char, flags)).length;
		}

		/**
		*	Levenshtein distance (editDistance) is a measure of the similarity between two strings,
		*	The distance is the number of deletions, insertions, or substitutions required to
		*	transform p_source into p_target.
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function editDistance(p_source:String, p_target:String):uint {
			var i:uint;

			if (p_source == null) { p_source = ''; }
			if (p_target == null) { p_target = ''; }

			if (p_source == p_target) { return 0; }

			var d:Array = new Array();
			var cost:uint;
			var n:uint = p_source.length;
			var m:uint = p_target.length;
			var j:uint;

			if (n == 0) { return m; }
			if (m == 0) { return n; }

			for (i=0; i<=n; i++) { d[i] = new Array(); }
			for (i=0; i<=n; i++) { d[i][0] = i; }
			for (j=0; j<=m; j++) { d[0][j] = j; }

			for (i=1; i<=n; i++) {

				var s_i:String = p_source.charAt(i-1);
				for (j=1; j<=m; j++) {

					var t_j:String = p_target.charAt(j-1);

					if (s_i == t_j) { cost = 0; }
					else { cost = 1; }

					d[i][j] = _minimum(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+cost);
				}
			}
			return d[n][m];
		}

		/**
		*	Determines whether the specified string contains text.
		*
		*	@param p_string The string to check.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function hasText(p_string:String):Boolean {
			var str:String = removeExtraWhitespace(p_string);
			return !!str.length;
		}

		/**
		*	Determines whether the specified string contains any characters.
		*
		*	@param p_string The string to check
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isEmpty(p_string:String):Boolean {
			if (p_string == null) { return true; }
			return !p_string.length;
		}

		/**
		*	Determines whether the specified string is numeric.
		*
		*	@param p_string The string.
		*
		*	@returns Boolean
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function isNumeric(p_string:String):Boolean {
			if (p_string == null) { return false; }
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return regx.test(p_string);
		}

		/**
		* Pads p_string with specified character to a specified length from the left.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padLeft(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s = p_padChar + s; }
			return s;
		}

		/**
		* Pads p_string with specified character to a specified length from the right.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function padRight(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s += p_padChar; }
			return s;
		}

		/**
		*	Properly cases' the string in "sentence format".
		*
		*	@param p_string The string to check
		*
		*	@returns String.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function properCase(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = p_string.toLowerCase().replace(/\b([^.?;!]+)/, capitalize);
			return str.replace(/\b[i]\b/, "I");
		}

		/**
		*	Escapes all of the characters in a string to create a friendly "quotable" sting
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function quote(p_string:String):String {
			var regx:RegExp = /[\\"\r\n]/g;
			return '"'+ p_string.replace(regx, _quote) +'"'; //"
		}

		/**
		*	Removes all instances of the remove string in the input string.
		*
		*	@param p_string The string that will be checked for instances of remove
		*	string
		*
		*	@param p_remove The string that will be removed from the input string.
		*
		*	@param p_caseSensitive An optional boolean indicating if the replace is case sensitive. Default is true.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function remove(p_string:String, p_remove:String, p_caseSensitive:Boolean = true):String {
			if (p_string == null) { return ''; }
			var rem:String = escapePattern(p_remove);
			var flags:String = (!p_caseSensitive) ? 'ig' : 'g';
			return p_string.replace(new RegExp(rem, flags), '');
		}

		/**
		*	Removes extraneous whitespace (extra spaces, tabs, line breaks, etc) from the
		*	specified string.
		*
		*	@param p_string The String whose extraneous whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function removeExtraWhitespace(p_string:String):String {
			if (p_string == null) { return ''; }
			var str:String = trim(p_string);
			return str.replace(/\s+/g, ' ');
		}

		/**
		*	Returns the specified string in reverse character order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverse(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split('').reverse().join('');
		}

		/**
		*	Returns the specified string in reverse word order.
		*
		*	@param p_string The String that will be reversed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function reverseWords(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.split(/\s+/).reverse().join('');
		}

		/**
		*	Determines the percentage of similiarity, based on editDistance
		*
		*	@param p_source The source string.
		*
		*	@param p_target The target string.
		*
		*	@returns Number
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function similarity(p_source:String, p_target:String):Number {
			var ed:uint = editDistance(p_source, p_target);
			var maxLen:uint = Math.max(p_source.length, p_target.length);
			if (maxLen == 0) { return 100; }
			else { return (1 - ed/maxLen) * 100; }
		}

		/**
		*	Remove's all < and > based tags from a string
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function stripTags(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/<\/?[^>]+>/igm, '');
		}

		/**
		*	Swaps the casing of a string.
		*
		*	@param p_string The source string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function swapCase(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/(\w)/, _swapCase);
		}

		/**
		*	Removes whitespace from the front (left-side) of the specified string.
		*
		*	@param p_string The String whose beginning whitespace will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function trimLeft(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+/, '');
		}

		/**
		*	Removes whitespace from the end (right-side) of the specified string.
		*
		*	@param p_string The String whose ending whitespace will be removed.
		*
		*	@returns String	.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function trimRight(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/\s+$/, '');
		}

		/**
		*	Determins the number of words in a string.
		*
		*	@param p_string The string.
		*
		*	@returns uint
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function wordCount(p_string:String):uint {
			if (p_string == null) { return 0; }
			return p_string.match(/\b\w+\b/g).length;
		}

		/**
		*	Returns a string truncated to a specified length with optional suffix
		*
		*	@param p_string The string.
		*
		*	@param p_len The length the string should be shortend to
		*
		*	@param p_suffix (optional, default=...) The string to append to the end of the truncated string.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function truncate(p_string:String, p_len:uint, p_suffix:String = "..."):String {
			if (p_string == null) { return ''; }
			p_len -= p_suffix.length;
			var trunc:String = p_string;
			if (trunc.length > p_len) {
				trunc = trunc.substr(0, p_len);
				if (/[^\s]/.test(p_string.charAt(p_len))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += p_suffix;
			}

			return trunc;
		}

		/* **************************************************************** */
		/*	These are helper methods used by some of the above methods.		*/
		/* **************************************************************** */
		private static function escapePattern(p_pattern:String):String {
			// RM: might expose this one, I've used it a few times already.
			return p_pattern.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');
		}

		private static function _minimum(a:uint, b:uint, c:uint):uint {
			return Math.min(a, Math.min(b, Math.min(c,a)));
		}

		private static function _quote(p_string:String, ...args):String {
			switch (p_string) {
				case "\\":
					return "\\\\";
				case "\r":
					return "\\r";
				case "\n":
					return "\\n";
				case '"':
					return '\\"';
				default:
					return '';
			}
		}

		private static function _upperCase(p_char:String, ...args):String {
			trace('cap latter ',p_char)
			return p_char.toUpperCase();
		}

		private static function _swapCase(p_char:String, ...args):String {
			var lowChar:String = p_char.toLowerCase();
			var upChar:String = p_char.toUpperCase();
			switch (p_char) {
				case lowChar:
					return upChar;
				case upChar:
					return lowChar;
				default:
					return p_char;
			}
		}
		
	}
	/*************************************************************************************************************/
}