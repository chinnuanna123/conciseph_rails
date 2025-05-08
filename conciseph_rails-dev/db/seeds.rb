# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u= User.create(
    {
        "email"=>"yogesh.thasale@concise.com",
        "phone"=>"(309) 261-4589",
        "password"=>'password',
        "provider"=>"email",
        "uid"=>"yogesh.thasale@concise.com",
        "name"=>"Yogesh",
        "is_admin"=>true
    }
)
Refer.create(
    {
        name: 'Test Refers',
        code: 'TEST100',
        no_of_users: 100,
        owner_id: u.id
    }
)

User.where(is_admin: false, referred_by: nil).limit(50).update_all(referred_by: Refer.find_by_code('TEST100').code)


# states =["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]



# states.map{|x| State.create(:name=>x)}
# p "started seeding document types"
# DocumentType.where(kind: 1).destroy_all
# dt = DocumentType.order('created_at DESC').first
# code = (dt.present?) ? (dt.code.to_i + 1) : 101
# DocumentType.where(kind: 0).each do |document_type|
#     DocumentType.where(:code=>code, name: document_type.name, kind: 1).first_or_create
#     code  = code + 1
# end


# ['Health Certificate','Vaccination Card','Pet Food'].each do |tp|
#     DocumentType.where(:code=>code, name: tp, kind: 1).first_or_create
#     code  = code + 1
# end
# p "document types done"

# p "started seeding document specialities"
# sp = Speciality.order('created_at DESC').first
# code = (sp.present?) ? (sp.code.to_i + 1) : 101
# ["Anesthesia and Analgesia","Animal welfare","Behavior","Dentistry","Dermatology","Emergency and Critical Care","Internal Medicine","Cardiology","Neurology","Oncology","Laboratory Animal medicine","Microbiology","Virology","Immunology","Bacteriology","Parasitology","Radiology","Sport Medicine and rehabilitation","Surgery","Theriogenology","Toxicology","Zoological Medicines"].each do |symptoms|
#     Speciality.where(:code=>code, name: symptoms, kind: 1).first_or_create
#     code  = code + 1
# end
# p "specialities done"

# p "started seeding immunization"
# im = Immunization.order('created_at DESC').first
# code = (im.present?) ? (im.code.to_i + 1) : 101
# ["Canine Parvovirus","Canine Distemper","Hepatitis","Rabies","Bordetella","Canine Influenza (dog flu)","Leptospirosis","Lyme vaccine","Rattlesnake vaccine","distemper,","parvovirus,","parainfluenza","Kennel Cough"].each do |immunization|
#     Immunization.where(:code=>code, name: immunization, kind: 1).first_or_create
#     code  = code + 1
# end
# p "immunization done"

# p "started seeding symptoms"
# sm = Symptom.order('created_at DESC').first
# code = (sm.present?) ? (sm.code.to_i + 1) : 101

# ["Abdomen - Painful","Abdomen - Swollen","Anorexia","Bad Breath","Blood in Stool","Blood in Urine","Breathing - Abnormal","Bleeding - Wounds","Bleeding From Ear","Bleeding From Nose","Bleeding From Paw","Blindness","Chewing or Licking Skin","Choking","Compulsive Grooming","Constipation","Coughing","Defecation - Straining","Dehydration","Disoriented","Drooling","Diarrhea","Dandruff","Deafness","Dragging Bottom","Dizziness","Defecation - Too Much","Ears - Discharge","Ears - Scratching","Ears - Swollen","Ears - Head Shaking","Ears - Foul Odor","Ears - Rubbing","Eating - Refusal to Eat","Eating - Regurgitation","Eating - Weight Gain","Eating Stool","Eyes - Discharge","Eyes - Red","Eyes - Squinting","Eyes - Tear Staining","Eyes - Third Eyelid","Eyes - Bulging","Eyes - Cloudy","Eyes - Discharge","Eyes - Pupils Different Sizes","Face - Swollen","Fever","Falling Down","Gagging","Gas","Hair Loss","Head Tilt","Head - Swollen","Heart Rate - Abnormal","Heat","Hot Spot","Head Shaking","Incontinence - Urinary","Itching and Scratching","Licking and Chewing Skin","Limping and Lameness","Lumps, Bumps, and Growths","Leg - Swollen","Lethargy","Losing Balance","Mouth - Bad Breath","Mouth - Difficulty Swallowing","Mouth - Sore","Mouth - Foreign Object","Mouth - Smacking Lips","Mouth Breathing","Nose - Bleeding","Nose - Discharge","Paralysis","Poisoning","Purring","Panting","Paws - Bleeding","Pregnancy","Regurgitation","Regurgitation","Runny Nose","Scratching and Itching","Seizures","Shedding","Scooting","Shivering","Skin - Itching and Scratching","Skin - Licking and Chewing","Skin - Oozing","Sneezing","Staggering","Stool - Bloody","Stool - Loose","Stool - Painful","Stool - Eating","Swollen Head","Urinary Incontinence","Urination - Frequent","Urination - Outside","Urination - Painful","Urination - Straining","Vomiting","Watery Eye","Weight Loss","Weight Gain"].each do |symptom|
#     Symptom.where(:code=>code, name: symptom, kind: 1).first_or_create
#     code  = code + 1
# end
# p "symptoms done"

# p "started seeding pet service providers"
# psp1 = PetServiceProvider.order('created_at DESC').first
# code = (psp1.present?) ? (psp1.code.to_i + 1) : 101

# ['Dog Training','Pets Hotel','Grooming Salon','Doggie Day Camp','Pet Taxi Service','Dog walking service','Pet Photographer','Post surgery recovery care','Pet Sitting','Dog Walking','Pet Boarding','Kennel Service'].each do |psp|
#     PetServiceProvider.where(:code=>code, name: psp, kind: 1).first_or_create
#     code  = code + 1
# end
# p "pet service providers done"


# p "started seeding payment types"
# PaymentType.where(kind: 1).destroy_all
# pt = PaymentType.order('created_at DESC').first
# code = (pt.present?) ? (pt.code.to_i + 1) : 101
# PaymentType.where(kind: 0).each do |payment_type|
#     PaymentType.where(:code=>code, name: payment_type.name, kind: 1).first_or_create
#     code  = code + 1
# end


# ['Pet Services'].each do |tp|
#     PaymentType.where(:code=>code, name: tp, kind: 1).first_or_create
#     code  = code + 1
# end
# p "payment types done"


50.times do
User.create!(
    email: Faker::Internet.email,
    password: "password",
    phone: Faker::PhoneNumber.phone_number,
    name: Faker::Name.name,
    nickname: Faker::Name.first_name,
    image: Faker::Avatar.image,
    uid: Faker::Number.number(digits: 10),
    provider: Faker::Internet.domain_name,
    is_admin: false,
    referred_by: nil,
    gender_on_birth_certificates: Faker::Number.between(from: 0, to: 1),
    preferred_language: Faker::Number.between(from: 0, to: 1),
    zip_code: Faker::Address.zip_code,
    height_ft: Faker::Number.between(from: 4, to: 6),
    height_inch: Faker::Number.between(from: 0, to: 11),
    blood_group: Faker::Number.between(from: 0, to: 7),
    birth_date: Faker::Date.birthday(min_age: 10, max_age: 90),
    gender: Faker::Number.between(from: 0, to: 1),
    ethnicity: Faker::Number.between(from: 0, to: 5)
  )
end
User.find_by(name: 'Yogesh').update(gender: "male" , birth_date: Date.today - 27.years , zip_code: "411010", ethnicity: "Latino" )


models = ["Goal", "Announcement", "MemberFeedback", "TimelyRecoveryGoal", "HealthEducation", "HealthEvent"]
models.each do |model|
  5.times do |ii|
    data =  {name: Faker::Appliance.equipment,
      "#{model.underscore}_type": model.classify.constantize.send("#{model.underscore}_types").to_a.sample.second,
      "#{model.underscore}_category": model.classify.constantize.send("#{model.underscore}_categories").to_a.sample.second,
      start_date: Date.today,
      end_date: Date.today + 12.months,
      section: model.classify.constantize.sections.to_a.sample.second,
      description: Faker::Company.catch_phrase}
    record = if model == "TimelyRecoveryGoal"
      model.classify.constantize.new(data.except(:start_date, :end_date))
    else
      model.classify.constantize.new(data)
    end
    if model != "TimelyRecoveryGoal"
      record.member_selections.build(
        "criteria_type"=>"Gender", "criterial_value"=>"0"
        )
    end
    
      5.times do |index|
        record.action_steps.build(
            {
              "name"=>"Step #{index}", 
              "message"=>"Message #{index}",
              "action"=>ActionStep.actions.to_a.sample.second, 
              "interaction"=> ActionStep.interactions.to_a.sample.second, 
              "artifact_type"=>"web_url", 
              "artifact_url"=>"ww.asda.com"}
        )
      end
    if record.valid?
    record.save!
    end
  end
end



    Goal.where(goal_type: nil).update_all(goal_type: 0)
    MemberFeedback.where(member_feedback_type: nil).update_all(member_feedback_type: 0)
    Compliance.where(compliance_type: nil).update_all(compliance_type: 0)
    HealthEducation.where(health_education_type: nil).update_all(health_education_type: 0)
    HealthEvent.where(health_event_type: nil).update_all(health_event_type: 0)
    Announcement.where(announcement_type: nil).update_all(announcement_type: 0)

    
    changes = {
      gender: 114,
      gender_on_birth_certificates: 114,
      ethnicity: 117,
      preferred_language: 113,
      blood_group: 119,
      speciality: 114
    }

    changes.each do |column_name, new_default|
      User.where(column_name => nil).update_all(column_name => new_default)
    end
