package ru.ganzin.apron2.zip.utils.zip
{
	import flash.utils.ByteArray;

	import nochump.util.zip.CRC32;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	import nochump.util.zip.ZipOutput;

	public class ZipUtil
	{
		static public function containsFile(zip:*, name:String):Boolean
		{
			var zipIn:ZipFile = zip as ZipFile;
			var zipOut:ZipOutput = zip as ZipOutput;

			if (zipIn) return zipIn.getEntry(name) != null;
			else if (zipOut)
			{
				zipOut = zipOut.clone();
				if (!zipOut.finished) zipOut.finish();
				zipIn = new ZipFile(zipOut.byteArray);
				return zipIn.getEntry(name) != null;
			}

			throw new ArgumentError("Zip data not found");
		}

		static public function removeFile(zip:*, name:String):*
		{
			var zipIn:ZipFile = zip as ZipFile;
			var zipOut:ZipOutput = zip as ZipOutput;

			if (zipIn)
			{
				zipOut = createZipOutput(zipIn, true, [name]);
				zipIn = new ZipFile(zipOut.byteArray);
				return zipIn;
			}
			else if (zipOut)
			{
				var finished:Boolean = zipOut.finished;
				zipOut = zipOut.clone();
				if (!zipOut.finished) zipOut.finish();
				zipIn = new ZipFile(zipOut.byteArray);
				return createZipOutput(zipIn, finished, [name]);
			}

			throw new ArgumentError("Zip data not found");
		}

		static public function getFile(zip:*, name:String):ByteArray
		{
			var zipIn:ZipFile = zip as ZipFile;
			var zipOut:ZipOutput = zip as ZipOutput;

			if (zipIn)
			{
				var entry:ZipEntry = zipIn.getEntry(name);
				if (!entry) return null;
				return zipIn.getInput(entry);
			}
			else if (zipOut)
			{
				zipOut = zipOut.clone();
				if (!zipOut.finished) zipOut.finish();
				zipIn = new ZipFile(zipOut.byteArray);
				return getFile(zipIn, name);
			}

			throw new ArgumentError("Zip data not found");
		}

		static public function createZipOutput(zip:ZipFile, finish:Boolean = false, ignoreFiles:Array = null):ZipOutput
		{
			var zipOut:ZipOutput = new ZipOutput();
			for each(var entry:ZipEntry in zip.entries)
			{
				if (ignoreFiles && ignoreFiles.indexOf(entry.name) != -1) continue;
				zipOut.putNextEntry(entry);
				zipOut.write(zip.getInput(entry));
				zipOut.closeEntry();
			}

			if (finish) zipOut.finish();

			return zipOut;
		}

		static public function createZipFile(zip:ZipOutput, ignoreFiles:Array = null):ZipFile
		{
			if (ignoreFiles)
				while(ignoreFiles.length) zip = removeFile(zip, ignoreFiles.pop());
			else zip = zip.clone();

			if (!zip.finished) zip.finish();
			return new ZipFile(zip.byteArray);
		}

		static public function addFile(zip:*, name:String, bytes:ByteArray):*
		{
			var zipIn:ZipFile = zip as ZipFile;
			var zipOut:ZipOutput = zip as ZipOutput;

			if (zipIn)
			{
				zipOut = createZipOutput(zipIn);
				zipOut.putNextEntry(new ZipEntry(name));
				zipOut.write(bytes);
				zipOut.closeEntry();
				zipOut.finish();
				return createZipFile(zipOut);
			}
			else if (zipOut)
			{
				var finished:Boolean = zipOut.finished;
				if (zipOut.size > 0)
				{
					zipIn = createZipFile(zipOut);
					zipOut = createZipOutput(zipIn);
				}
				zipOut.putNextEntry(new ZipEntry(name));
				zipOut.write(bytes);
				zipOut.closeEntry();
				if (finished) zipOut.finish();
				return zipOut;
			}

			throw new ArgumentError("Zip data not found");
		}

		static public function getBytes(zip:*):ByteArray
		{
			var zipIn:ZipFile = zip as ZipFile;
			var zipOut:ZipOutput = zip as ZipOutput;

			if (zipIn)
			{
				zipOut = createZipOutput(zipIn,true);
				return zipOut.byteArray;
			}
			else if (zipOut)
			{
				zipOut = zipOut.clone();
				if (!zipOut.finished) zipOut.finish();
				return zipOut.byteArray;
			}

			throw new ArgumentError("Zip data not found");
		}

		static public function getCRC32(bytes:ByteArray):uint
		{
			var crc:CRC32 = new CRC32();
			crc.update(bytes);
			return crc.getValue();
		}
	}
}
