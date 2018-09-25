require("pg")

class Bounty

  attr_reader :name, :danger_level, :favourite_weapon, :id
  attr_accessor :bounty_value

  def initialize(bounty)
    @name = bounty["name"]
    @bounty_value = bounty["bounty_value"].to_i
    @danger_level = bounty["danger_level"]
    @favourite_weapon = bounty["favourite_weapon"]
    @id = bounty["id"].to_i
  end

  def save()
    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
      })

    sql = "
      INSERT INTO bounties (
        name,
        bounty_value,
        danger_level,
        favourite_weapon
      )
      VALUES ($1, $2, $3, $4)
      RETURNING id;
      "

    values = [@name, @bounty_value, @danger_level, @favourite_weapon]
    db.prepare("save", sql)
    pg_array_thing = db.exec_prepared("save", values)
    db.close
    @id = pg_array_thing[0]["id"].to_i
  end

  def self.delete_all()
    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
      })

    sql = "DELETE FROM bounties;"

    db.exec(sql)
    db.close
  end

  def self.all()
    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
      })

    sql = "SELECT * FROM bounties;"

    db.prepare("all", sql)
    bounty_array_of_hashes = db.exec_prepared("all")
      # gives back array type thing (of hashes)
    db.close
    bounty_objects = bounty_array_of_hashes.map { |bounty_hash|
      Bounty.new(bounty_hash)
    }
      # turns each hash into a Bounty object in the array
    return bounty_objects
      # returns the array of objects
  end

  # update the database with current object data
  def update()
    db = PG.connect({
      dbname: "bounty_hunter",
      host: "localhost"
      })

    sql = "
      UPDATE bounties
      SET (
        name,
        bounty_value,
        danger_level,
        favourite_weapon
      ) = ($1, $2, $3, $4)
      WHERE id = $5;
    "
    values = [
      @name,
      @bounty_value,
      @danger_level,
      @favourite_weapon,
      @id
    ]

    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close
  end

end
