-- Update topic names in tasks table
UPDATE tasks 
SET topic = CASE 
  WHEN topic = 'Waste & Plastic Pollution' THEN 'Plastronauts'
  WHEN topic = 'Air Pollution' THEN 'Aether Shield'
  WHEN topic = 'Water Pollution & Conservation' THEN 'Hydronauts'
  WHEN topic = 'Climate Change' THEN 'ChronoClimbers'
  WHEN topic = 'Deforestation & Biodiversity Loss' THEN 'Verdantra'
  WHEN topic = 'Soil & Land Degradation' THEN 'TerraFixers'
  WHEN topic = 'Industrial & Urban Pollution' THEN 'SmogSmiths'
  WHEN topic = 'Lack of Awareness & Environmental Education' THEN 'EcoMentors'
  ELSE topic 
END;

-- Update topic names in user_topic_progress table
UPDATE user_topic_progress
SET topic = CASE 
  WHEN topic = 'Waste & Plastic Pollution' THEN 'Plastronauts'
  WHEN topic = 'Air Pollution' THEN 'Aether Shield'
  WHEN topic = 'Water Pollution & Conservation' THEN 'Hydronauts'
  WHEN topic = 'Climate Change' THEN 'ChronoClimbers'
  WHEN topic = 'Deforestation & Biodiversity Loss' THEN 'Verdantra'
  WHEN topic = 'Soil & Land Degradation' THEN 'TerraFixers'
  WHEN topic = 'Industrial & Urban Pollution' THEN 'SmogSmiths'
  WHEN topic = 'Lack of Awareness & Environmental Education' THEN 'EcoMentors'
  ELSE topic 
END;
