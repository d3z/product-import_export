# Simple file handler that reads contents of 
# file to string and writes string straight
# to file
class DefaultFileHandler
    
    def read_data_from(filename)
        file = File.open(filename, "r")
        file.read
    end

    def write_data_to(filename, data)
        File.open(filename, "w") { |file| 
            file.write(data)
        }
    end

end