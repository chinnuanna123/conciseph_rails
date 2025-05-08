# frozen_string_literal: true

module ApplicationHelper
  def fake_user_name
    ['Abigail Rose', 'Abraham Miller', 'Amelia Garcia', 'Andrew Williams', 'Anna Brown', 'Anthony Moore',
     'Ashley Rodriguez', 'Benjamin Walker', 'Bethany Hernandez', 'Blake Johnson', 'Brenda Lopez', 'Brian Lewis', 'Caitlin Garcia', 'Caleb Martin', 'Camille Hernandez', 'Cameron Robinson', 'Carly Jackson', 'Chad Harris', 'Christina Lopez', 'Christopher Rodriguez', 'Claire Hernandez', 'Cristian Walker', 'Courtney Jackson', 'Daniel Brown', 'Danielle Moore', 'David Williams', 'Dawn Garcia', 'Dean Hernandez', 'Debra Robinson', 'Diego Miller', 'Donna Martin', 'Dylan Garcia', 'Elizabeth Johnson', 'Erik Lewis', 'Emily Hernandez', 'Ethan Lopez', 'Evelyn Rodriguez', 'Felix Hernandez', 'Fiona Robinson', 'Gabriel Walker', 'Gabrielle Lopez', 'George Williams', 'Grace Garcia', 'Greg Hernandez', 'Hannah Robinson', 'Harrison Walker', 'Hayley Lopez', 'Henry Brown', 'Heather Hernandez', 'Ian Garcia', 'Isabella Robinson', 'Isaac Walker', 'Isabella Hernandez', 'Jacob Garcia', 'Jasmine Miller', 'Jeremy Hernandez', 'Jessica Lopez', 'John Robinson', 'Jordan Walker', 'Julia Rodriguez', 'Justin Hernandez', 'Karen Lopez', 'Kevin Walker', 'Kayla Brown', 'Kenneth Garcia', 'Kimberly Hernandez', 'Kyle Robinson', 'Laura Brown', 'Lawrence Williams', 'Leah Robinson', 'Liam Garcia', 'Lillian Rodriguez', 'Lucas Brown', 'Lucy Hernandez', 'Mark Garcia', 'Mary Robinson', 'Matthew Williams', 'Megan Lopez', 'Michael Brown', 'Michelle Garcia', 'Mitchell Hernandez', 'Nicole Williams', 'Noah Garcia', 'Olivia Hernandez', 'Oliver Robinson', 'Olivia Brown', 'Owen Williams', 'Paige Lopez', 'Patrick Garcia', 'Penelope Hernandez', 'Peter Brown', 'Rachel Garcia', 'Richard Hernandez', 'Rebecca Brown', 'Robert Lopez', 'Robin Hernandez', 'Ryan Lopez', 'Samantha Williams', 'Samuel Brown', 'Sarah Hernandez', 'Aaron Davis', 'Alice Evans', 'Brandon Moore', 'Bridget Williams', 'Charles Brown', 'Charlotte Garcia', 'David Lopez', 'Deborah Miller', 'Derek Robinson', 'Diana Walker', 'Elijah Hernandez', 'Elizabeth Lewis', 'Emily Brown', 'Eric Martin', 'Erin Robinson', 'Ethan Jackson', 'Evelyn Harris', 'Felix Lopez', 'Fiona Garcia', 'Gabriel Lewis', 'Gabriella Brown', 'George Robinson', 'Grace Jackson', 'Greg Harris', 'Hannah Lopez', 'Harrison Garcia', 'Hayley Lewis', 'Henry Brown', 'Heather Robinson', 'Ian Martin', 'Isabella Lewis', 'Isaac Brown', 'Isabella Robinson', 'Jacob Jackson', 'Jasmine Harris', 'Jeremy Lopez', 'Jessica Garcia', 'John Lewis', 'Jordan Brown', 'Julia Robinson', 'Justin Jackson', 'Karen Harris', 'Kevin Lopez', 'Kayla Garcia', 'Kenneth Lewis', 'Kimberly Brown', 'Kyle Robinson', 'Laura Martin', 'Lawrence Garcia', 'Leah Lewis', 'Liam Brown', 'Lillian Robinson', 'Lucas Martin', 'Lucy Garcia', 'Mark Lewis', 'Mary Brown', 'Matthew Robinson', 'Megan Garcia', 'Michael Lewis', 'Michelle Brown', 'Mitchell Robinson', 'Nicole Martin', 'Noah Garcia', 'Olivia Lewis', 'Oliver Brown', 'Olivia Robinson', 'Owen Martin', 'Paige Garcia', 'Patrick Lewis', 'Penelope Brown', 'Peter Robinson', 'Rachel Martin', 'Richard Garcia', 'Rebecca Lewis', 'Robert Brown', 'Robin Robinson', 'Ryan Martin', 'Samantha Garcia', 'Samuel Lewis', 'Sarah Brown', 'Timothy Brown', 'Tina Lopez', 'Tom Martin', 'Valerie Garcia', 'Vanessa Lewis', 'Alexander Garcia', 'Alexis Hernandez', 'Amanda Brown', 'Andrew Lewis', 'Angela Jackson', 'Anthony Brown', 'Ashley Miller', 'Benjamin Robinson', 'Bethany Martin', 'Blake Garcia', 'Brenda Hernandez', 'Brian Lopez', 'Caitlin Walker', 'Caleb Brown', 'Camille Lewis', 'Cameron Garcia', 'Carly Hernandez', 'Chad Robinson', 'Christina Brown', 'Christopher Lopez', 'Claire Garcia', 'Cristian Lewis', 'Courtney Brown', 'Daniel Hernandez', 'Danielle Lopez', 'David Garcia', 'Dawn Brown', 'Dean Lewis', 'Debra Jackson', 'Diego Hernandez', 'Donna Lopez', 'Dylan Garcia', 'Elizabeth Miller', 'Erik Robinson', 'Emily Martin', 'Ethan Garcia', 'Evelyn Hernandez', 'Felix Lopez', 'Fiona Brown', 'Gabriel Jackson', 'Gabrielle Hernandez', 'George Lopez', 'Grace Martin', 'Greg Brown', 'Hannah Lewis', 'Harrison Garcia', 'Hayley Brown', 'Henry Miller', 'Heather Robinson', 'Ian Hernandez', 'Isabella Garcia', 'Isaac Brown', 'Isabella Lopez', 'Jacob Martin', 'Jasmine Brown', 'Jeremy Hernandez', 'Jessica Garcia', 'John Lopez', 'Jordan Hernandez', 'Julia Lopez', 'Justin Brown', 'Karen Miller', 'Kevin Robinson', 'Kayla Garcia', 'Kenneth Brown', 'Kimberly Lopez', 'Kyle Martin', 'Laura Jackson', 'Lawrence Hernandez', 'Leah Brown', 'Liam Miller', 'Lillian Robinson', 'Lucas Jackson', 'Lucy Garcia', 'Mark Brown', 'Mary Miller', 'Matthew Robinson', 'Megan Garcia', 'Michael Hernandez', 'Michelle Lopez', 'Mitchell Brown', 'Nicole Miller', 'Noah Garcia', 'Olivia Hernandez', 'Oliver Lopez', 'Olivia Miller', 'Owen Robinson', 'Paige Garcia', 'Patrick Brown', 'Penelope Miller', 'Peter Robinson', 'Rachel Garcia', 'Richard Hernandez', 'Rebecca Miller', 'Robert Lopez', 'Robin Brown', 'Ryan Martin', 'Samantha Hernandez', 'Samuel Brown', 'Sarah Lopez'].uniq.sample
  end

  def link_to_remove_association(name, f)
    f.hidden_field(:_destroy) + link_to(name, '#', class: 'remove_fields')
  end

  def link_to_remove_association_for_criteria(name, f)
    f.hidden_field(:_destroy) + link_to(name, '#', class: 'remove_fields_criteria')
  end

  def link_to_remove_association_for_milestone(name, f, class_name)
    f.hidden_field(:_destroy) + link_to(name, '#', class: class_name)
  end

  def link_to_add_association(name, f, association, partial, local_var, classes= "")
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(partial, f: builder, goal: local_var)
    end
    link_to(name, '#', class: "#{classes} add_fields", data: { id: new_object.object_id, fields: fields.gsub("\n", '') })
  end

  def link_to_add_association_for_criteria(name, f, association, partial, local_var, classes= "")
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(partial, f: builder, goal: local_var)
    end
    link_to(name, '#', class: "#{classes} add_fields_criteria",
                       data: { id: new_object.object_id, fields: fields.gsub("\n", '') })
  end

  def link_to_add_association_for_milestones(name, f, association, partial, local_var, classes= "")
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object.action_steps.build
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|

      render(partial, f: builder, goal: local_var, disabled: false)
    end
    link_to(name, '#', class: classes,
                       data: { id: new_object.object_id, fields: fields.gsub("\n", '') })
  end

  def blank_if_na(data)
    return '' if data.blank? || (data.present? && data == 'NA')

    data.titleize
  end

  def format_date_time(date_time)
    return nil unless date_time.present?

    date_time.strftime('%m-%d-%Y | %I:%M %p')
  end

  def format_date(date)
    return nil unless date.present?

    date.strftime('%m-%d-%Y')
  end
end
