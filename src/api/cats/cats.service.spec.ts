import { Test, TestingModule } from '@nestjs/testing';
import { CatsService } from './cats.service';
import { CreateCatDto } from './dto/create-cat.dto';

describe('CatsService', () => {
  let service: CatsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CatsService],
    }).compile();

    service = module.get<CatsService>(CatsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create a cat', async () => {
      const createCatDto: CreateCatDto = {}
      expect(service.create(createCatDto)).toBe('This action adds a new cat')
    })
  })
  describe('findAll', () => {
    it('should return an array of cats', async () => {
      expect(service.findAll()).toBe('This action returns all cats')
    })
  })
  describe('findOne', () => {
    it('should return a cat', async () => {
      const id = 7
      expect(service.findOne(id)).toBe(`This action returns a #${id} cat`)
    })
  })
  describe('update', () => {
    it('should update a cat', async () => {
      const id = 7
      const createCatDto: CreateCatDto = {}
      expect(service.update(id, createCatDto)).toBe(`This action updates a #${id} cat`)
    })
  })
  describe('remove', () => {
    it('should remove a cat', async () => {
      const id = 7
      expect(service.remove(id)).toBe(`This action removes a #${id} cat`)
    })
  })
});
