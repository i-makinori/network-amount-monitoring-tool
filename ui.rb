#encoding:UTF-8
require 'tk'

load 'main.rb'

def si_info_prefix (amount, index=0)
  if amount >= 1024 then
    si_info_prefix(amount/1024, index+1)
  else
    return amount.to_s + " " +
      if index == 0 then ""
      elsif index == 1 then "k"
      elsif index == 2 then "M"
      elsif index == 3 then "G"
      elsif index == 4 then "T"
      elsif index == 5 then "P"
      else "*1024^#{index}"
      end + "B"
  end
end

class GUI < App

  @tree = "tree"
  
  def initialize ()
    super()
    
    set_tree 
  end

  
  def set_tree ()
    @tree = Ttk::Treeview.new(show: :headings).pack
    @tree['columns'] = 'Date Receive Transmit total'
    @tree['columns'].zip(%w(Date Recieve Transmit Total)).each {|col, name|
      @tree.heading_configure(col, text:name)
    }
    
    @communicate_logs.map{|log|
      date  = log.date.year.to_s + "/"+log.date.month.to_s + "/" + log. date.day.to_s
      trans = log.communicate_list.map{|c| c.transmit}.inject(0) {|x,y| x+y}
      reci  = log.communicate_list.map{|c| c.receive }.inject(0) {|x,y| x+y}
      @tree.insert(value:[date, si_info_prefix(reci),
                          si_info_prefix(trans), si_info_prefix(reci+trans)])
    }
  end

  def set_graph ()
  end
  
  def loop ()
    Tk.mainloop
  end

end


log_list = (read_log_file LOG_FILE).sort {|a, b|
  a.date.year * 366 + a.date.month * 12 + a.date.day <=>
  b.date.year * 366 + b.date.month * 12 + b.date.day
}


gui = GUI.new()
#gui.set_tree_items(read_log_file LOG_FILE)
gui.loop()
